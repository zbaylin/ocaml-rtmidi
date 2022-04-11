open Ctypes

module Make (T : TYPE) = struct
  open T

  let c_enum ~typedef name mapping =
    let mapping' =
      List.map (fun (variant, enum) -> (variant, constant enum int64_t)) mapping
    in
    let unexpected v =
      invalid_arg @@ Format.sprintf "Got unexpected value %Ld for %s" v name
    in
    enum ~typedef name mapping' ~unexpected

  module Wrapper = struct
    type t

    let t : t structure typ = structure "RtMidiWrapper"
  end

  module Error = struct
    type t =
      | Warning
      | Debug_warning
      | Unspecified
      | No_devices_found
      | Invalid_device
      | Memory_error
      | Invalid_parameter
      | Invalid_use
      | Driver_error
      | System_error
      | Thread_error

    let t =
      c_enum ~typedef:false "RtMidiErrorType"
        [
          (Warning, "RTMIDI_ERROR_WARNING");
          (Debug_warning, "RTMIDI_ERROR_DEBUG_WARNING");
          (Unspecified, "RTMIDI_ERROR_UNSPECIFIED");
          (No_devices_found, "RTMIDI_ERROR_NO_DEVICES_FOUND");
          (Invalid_device, "RTMIDI_ERROR_INVALID_DEVICE");
          (Memory_error, "RTMIDI_ERROR_MEMORY_ERROR");
          (Invalid_parameter, "RTMIDI_ERROR_INVALID_PARAMETER");
          (Invalid_use, "RTMIDI_ERROR_INVALID_USE");
          (Driver_error, "RTMIDI_ERROR_DRIVER_ERROR");
          (System_error, "RTMIDI_ERROR_SYSTEM_ERROR");
          (Thread_error, "RTMIDI_ERROR_THREAD_ERROR");
        ]
  end

  module Api = struct
    type t =
      | Unspecified
      | Macosx_core
      | Linux_alsa
      | Unix_jack
      | Windows_mm
      | Dummy

    let t =
      c_enum ~typedef:false "RtMidiApi"
        [
          (Unspecified, "RTMIDI_API_UNSPECIFIED");
          (Macosx_core, "RTMIDI_API_MACOSX_CORE");
          (Linux_alsa, "RTMIDI_API_LINUX_ALSA");
          (Unix_jack, "RTMIDI_API_UNIX_JACK");
          (Windows_mm, "RTMIDI_API_WINDOWS_MM");
          (Dummy, "RTMIDI_API_RTMIDI_DUMMY");
        ]
  end
end
