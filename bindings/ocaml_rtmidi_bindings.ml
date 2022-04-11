open Ctypes
module Types = Ocaml_rtmidi_types.Make (Ocaml_rtmidi_generated_types)

module Make (F : FOREIGN) = struct
  open F

  type t = Types.Wrapper.t structure ptr

  let t = ptr Types.Wrapper.t

  let callback =
    Ctypes.(double @-> ptr uchar @-> ulong @-> ptr void @-> returning void)

  let get_port_count = foreign "rtmidi_get_port_count" (t @-> returning uint)

  let get_port_name =
    foreign "rtmidi_get_port_name"
      (t @-> uint @-> ptr_opt char @-> ptr int @-> returning int)

  let open_port =
    foreign "rtmidi_open_port" (t @-> uint @-> string @-> returning void)

  module Api = struct
    type t = Types.Api.t =
      | Unspecified
      | Macosx_core
      | Linux_alsa
      | Unix_jack
      | Windows_mm
      | Dummy

    let t = Types.Api.t
    let name = foreign "rtmidi_api_name" (Types.Api.t @-> returning string)

    let display_name =
      foreign "rtmidi_api_display_name" (Types.Api.t @-> returning string)
  end

  module In = struct
    type t = Types.Wrapper.t structure ptr

    let t = ptr Types.Wrapper.t

    let create_default =
      foreign "rtmidi_in_create_default" (void @-> returning t)

    let create =
      foreign "rtmidi_in_create" (Api.t @-> string @-> uint @-> returning t)

    let free = foreign "rtmidi_in_free" (t @-> returning void)

    let get_message =
      foreign "rtmidi_in_get_message"
        (t @-> ptr_opt uchar @-> ptr size_t @-> returning float)

    let get_current_api =
      foreign "rtmidi_in_get_current_api" (t @-> returning Api.t)

    let ignore_types =
      foreign "rtmidi_in_ignore_types"
        (t @-> bool @-> bool @-> bool @-> returning void)
  end
end
