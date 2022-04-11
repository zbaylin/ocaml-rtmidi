open Configurator.V1
open Flags

type os = Mac | Linux

let uname () =
  let ic = Unix.open_process_in "uname" in
  let uname = input_line ic in
  let (_ : Unix.process_status) = Unix.close_process_in ic in
  uname

let get_os () =
  match uname () with
  | "Darwin" -> Mac
  | "Linux" -> Linux
  | os -> failwith @@ "Unsupported OS: " ^ os

let framework f = [ "-framework"; f ]

let libs = function
  | Mac ->
      [ "-L" ^ Sys.getenv "INSIDE_DUNE" ^ "/bindings"; "-lrtmidi"; "-lstdc++" ]
      @ framework "CoreMIDI" @ framework "CoreAudio"
      @ framework "CoreFoundation"
  | Linux -> [ "-L."; "-lasound"; "-lpthread"; "-lrtmidi" ]

let () =
  main ~name:"ocaml_rtmidi_discover" (fun _ ->
      let os = get_os () in
      write_lines "c_library_flags.txt" (libs os);
      write_sexp "c_library_flags.sexp" (libs os))
