open Battle_event
open Config
open! Postgresql

let create_postgresql_persister config =
  let c =
    try new connection ~conninfo:config.postgres_conn_string () with
    | Error e ->
        prerr_endline (string_of_error e) ;
        exit 34
    | e ->
        prerr_endline (Printexc.to_string e) ;
        exit 3
  in
  fun battle_event ->
    try
      let query = Printf.sprintf "INSERT INTO id VALUES('%s')" (c#escape_string battle_event.id) in
      let res = c#exec query in
      match res#status with
      | Command_ok -> print_endline "Insert successful" ; battle_event
      | _ -> print_endline "Insert failed" ; battle_event
    with Error _ -> print_endline c#error_message ; battle_event
