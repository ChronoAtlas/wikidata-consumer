let () =
  let open Alcotest in
  run "Wikidata_consumer"
    [ ("Daemon", [("test_run", `Quick, Test_daemon.test_run); ("test_run_empty", `Quick, Test_daemon.test_run_empty)])
    ; ( "Parser"
      , [ ("test_parser", `Quick, Test_parser.test_parser)
        ; ("test_parser_with_null", `Quick, Test_parser.test_parser_with_null) ] ) ]
