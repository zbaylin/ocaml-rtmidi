open Ocaml_rtmidi
open Lwt.Infix

let pp_char_hex fmt c = Fmt.pf fmt "%x" (Char.code c)

let () =
  Logs.set_reporter (Logs_fmt.reporter ());
  Logs.set_level (Some Logs.Info);
  let in_ = In.create_default () in
  let generic = in_ |> of_in in
  let api = In.get_current_api in_ in
  let port_count = generic |> get_port_count in
  let port_0_name = get_port_name generic 0 in
  Logs.info (fun m ->
      m {|OCaml RtMidi:
  API: %s
  Port count: %d
  Port 0 name: %s|}
        (api |> Api.display_name) port_count port_0_name);
  In.ignore_types ~sysex:false ~sense:false ~time:false in_;
  open_port generic 0 "RtMidi";
  let stream = Ocaml_rtmidi_lwt.In.message_stream in_ in
  let rec helper () =
    Lwt_stream.get stream >>= function
    | None -> helper ()
    | Some (dt, data) ->
        Logs_lwt.info (fun m ->
            m "Received MIDI data: %a (dt = %f)"
              (Fmt.array ~sep:Fmt.comma pp_char_hex)
              data dt)
        >>= helper
  in
  Lwt_main.run @@ helper ()
