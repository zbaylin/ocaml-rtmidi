type t

val get_port_count : t -> int
val get_port_name : t -> int -> string
val open_port : t -> int -> string -> unit

module Api : sig
  type t =
    | Unspecified
    | Macosx_core
    | Linux_alsa
    | Unix_jack
    | Windows_mm
    | Dummy

  val name : t -> string
  val display_name : t -> string
end

module In : sig
  type t

  val create_default : unit -> t
  val create : Api.t -> string -> Unsigned.UInt.t -> t
  val get_current_api : t -> Api.t
  val get_message : t -> float * char array
  val ignore_types : sysex:bool -> time:bool -> sense:bool -> t -> unit
end

val of_in : In.t -> t
