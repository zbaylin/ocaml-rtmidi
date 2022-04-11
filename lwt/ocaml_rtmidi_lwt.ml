open Ocaml_rtmidi
open Lwt.Infix

module In = struct
  let message_stream ?(wait_time_s = 0.01) in_ =
    let rec helper () =
      Lwt_unix.sleep wait_time_s >>= fun () ->
      let dt, data = In.get_message in_ in
      if dt > 0. then Lwt.return (Some (dt, data)) else helper ()
    in
    Lwt_stream.from helper
end
