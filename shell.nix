let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in


pkgs.mkShell{
  packages = with pkgs; [
    libpqxx
    ocamlPackages.alcotest
    ocamlPackages.base
    ocamlPackages.bisect_ppx
    ocamlPackages.caqti
    ocamlPackages.caqti-driver-postgresql
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
