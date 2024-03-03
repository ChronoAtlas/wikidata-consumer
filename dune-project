(lang dune 3.14)
(name wikidata-consumer)
(generate_opam_files true)
(source
 (github ChronoAtlas/wikidata-consumer))
(authors "Andreas Krühlmann")
(maintainers "echo 'YW5kcmVhc0BrcnVobG1hbm4uZGV2Cg==' | base64 -d")
(license MIT)
(documentation https://github.com/ChronoAtlas/wikidata-consumer)
(package
 (name wikidata-consumer-lib)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends
  (ocaml (>= 4.08))
  (alcotest (and :with-test (>= 1.3.0)))
  (base (>= v0.12.0))
  (cmdliner (>= 1.1.0))
  dune
  dune-build-info)
 (tags
  (topics "to describe" your project)))
(package
 (name wikidata-consumer)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends
  (ocaml (>= 4.08))
  (lwt (>= 5.7.0))
  (kafka_lwt (>= 0.5))
  (postgresql (>= 5.0.0))
  (yojson (>= 2.1.2))
  (alcotest (and :with-test (>= 1.3.0)))
  (bisect_ppx (and :with-test (>= 2.3.0)))
  (ocamlformat (and :with-dev-setup (>= 0.26.1)))
  (base (>= v0.12.0))
  (cmdliner (>= 1.1.0))
  dune
  dune-build-info)
 (tags
  (topics "to describe" your project)))
