(lang dune 3.0)

(name ocaml-rtmidi)

(license MIT)
(maintainers "Zach Baylin <me@zachbayl.in>")
(authors "Zach Baylin <me@zachbayl.in>")

(source (github zbaylin/ocaml-rtmidi))

(generate_opam_files true)

(package
  (name ocaml-rtmidi)
  (synopsis "OCaml bindings to the RtMidi library")
  (depends
    (ocaml (>= 4.08.0))))
