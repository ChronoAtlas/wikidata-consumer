let () =
  let open Alcotest in
  run "Daemon" [("run_daemon", [("test_run_daemon", `Slow, Test_daemon.run_test)])]
