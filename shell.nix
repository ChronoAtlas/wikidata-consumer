let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in


pkgs.mkShell{
  packages = with pkgs; [
    libpqxx
    mongoc
    ocamlPackages.alcotest
    ocamlPackages.base
    ocamlPackages.bisect_ppx
    ocamlPackages.cmdliner
    ocamlPackages.kafka_lwt
    ocamlPackages.lwt
    ocamlPackages.ocaml
    ocamlPackages.ocamlformat
    ocamlPackages.odoc
    ocamlPackages.utop
    ocamlPackages.yojson
    opam
    pkg-config
    rdkafka
    zlib
  ];
}
