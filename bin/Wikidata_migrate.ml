open Wikidata_consumer_lib

let () =
  let migration_method = Sys.argv.(1) in
  let conn_str = Sys.argv.(2) in
  match migration_method with
    | "upgrade" -> begin match Migration.upgrade conn_str with
        | Ok () -> Printf.printf "Upgrade succeeded\n"
        | _ -> Printf.printf "Upgrade failed\n"
    end
    | "downgrade" -> begin match Migration.downgrade conn_str with
        | Ok () -> Printf.printf "Downgrade succeeded\n"
        | _ -> Printf.printf "Downgrade failed\n"
    end
    | _ -> Printf.printf "Invalid method %s\n" migration_method
