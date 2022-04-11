let preamble = {|
#include "rtmidi_c.h"
|}

let () =
  print_endline preamble;
  Cstubs.Types.write_c Format.std_formatter (module Ocaml_rtmidi_types.Make)
