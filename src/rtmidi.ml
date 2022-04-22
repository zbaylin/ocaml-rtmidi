open Ctypes
module Bindings = Rtmidi_bindings.Make (Rtmidi_generated_stubs)

type t = Bindings.t

let get_port_count t = Bindings.get_port_count t |> Unsigned.UInt.to_int

let get_port_name t idx =
  let idx_uint = Unsigned.UInt.of_int idx in
  let len_ptr = allocate int 0 in
  let (_ : int) = Bindings.get_port_name t idx_uint None len_ptr in
  let len = !@len_ptr in
  let arr = Ctypes.CArray.make char len in
  let (_ : int) =
    Bindings.get_port_name t idx_uint (Some (arr |> CArray.start)) len_ptr
  in
  String.init len (fun i -> CArray.get arr i)

let open_port t i str = Bindings.open_port t (Unsigned.UInt.of_int i) str

module Api = struct
  type t = Bindings.Api.t =
    | Unspecified
    | Macosx_core
    | Linux_alsa
    | Unix_jack
    | Windows_mm
    | Dummy

  let display_name = Bindings.Api.display_name
  let name = Bindings.Api.name
end

module In = struct
  type t = Bindings.In.t

  let message_size = 1024
  let message_buffer = CArray.make uchar message_size

  let create_default () =
    let default = Bindings.In.create_default () in
    Gc.finalise (fun v -> Bindings.In.free v) default;
    default

  let create api client_name queue_size_limit =
    let in' = Bindings.In.create api client_name queue_size_limit in
    Gc.finalise (fun v -> Bindings.In.free v) in';
    in'

  let get_current_api = Bindings.In.get_current_api

  let get_message t =
    let len_ptr = allocate size_t (Unsigned.Size_t.of_int message_size) in
    let dt =
      Bindings.In.get_message t (Some (CArray.start message_buffer)) len_ptr
    in
    let arr =
      Array.init (!@len_ptr |> Unsigned.Size_t.to_int) (fun i ->
          CArray.get message_buffer i
          |> Unsigned.UChar.to_int |> Char.unsafe_chr)
    in
    (dt, arr)

  let ignore_types ~sysex ~time ~sense t =
    Bindings.In.ignore_types t sysex time sense
end

let of_in : In.t -> t = Fun.id
