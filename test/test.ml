let () =
  let open Alcotest in
  run "Daemon" [("run_daemon", [("test_run_daemon", `Quick, Test_daemon.run_test)])]
