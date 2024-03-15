FROM cr.kruhlmann.dev/debian-bookworm-ocaml-4.14.0

USER dockeruser

COPY *.opam .
RUN opam env
