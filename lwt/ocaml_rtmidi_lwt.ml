open Ocaml_rtmidi
open Lwt.Infix

module In = struct
  let message_stream ?(poll_time_s = 0.001) in_ =
    let rec helper () =
      Lwt_unix.sleep poll_time_s >>= fun () ->
      let dt, data = In.get_message in_ in
      if dt > 0. then Lwt.return (Some (dt, data)) else helper ()
    in
    Lwt_stream.from helper
end
