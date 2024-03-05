open Wikidata_consumer_lib

let () =
  let _method = Sys.argv.(1) in
  let conn_str = Sys.argv.(2) in
  match Migration.upgrade conn_str with
  | Ok () -> Printf.printf "Upgrade successful.\n"
  | Error e -> Printf.eprintf "Upgrade failed: %s\n" (Caqti_error.show e)
