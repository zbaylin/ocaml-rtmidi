type generate = C | Ml

module Cli = struct
  open Cmdliner

  let generate_term =
    let info = Arg.info [] ~doc:"Type of code to generate, C or OCaml" in
    Arg.required
      (Arg.pos 0 (Arg.some (Arg.enum [ ("c", C); ("ml", Ml) ])) None info)
end

let cmdline_term =
  let open Cli in
  Cmdliner.Term.(const Fun.id $ generate_term)

let parse_cli () =
  let open Cmdliner in
  let info = Cmd.info "rtmidi_gen_code" in
  match Cmd.eval_value (Cmd.v info cmdline_term) with
  | Ok (`Ok generate) -> generate
  | _ -> exit 1

let prefix = "rtmidi_wrapped"

let c_prologue = {|
#include "rtmidi_c.h"
|}

let () =
  match parse_cli () with
  | Ml ->
      Cstubs.write_ml Format.std_formatter ~prefix (module Rtmidi_bindings.Make)
  | C ->
      print_endline c_prologue;
      Cstubs.write_c Format.std_formatter ~prefix (module Rtmidi_bindings.Make)
