open Wikidata_consumer_lib
open Cmdliner

let run config =
  let curried_consume () = Kafka_consumer.consume_with_config config in
  let curried_mongo_persist = Mongo_persister.processor_curried config in
  let () =
    at_exit (fun () ->
      let _ = Lwt_io.printf "Running mongoc cleanup\n" in
      Mongo_driver.mongoc_cleanup ())
  in
  Lwt_main.run (Daemon.run_daemon curried_consume [ curried_mongo_persist ])
;;

let () =
  let config_term = Cli.build_cli_args () in
  let run_term = Term.(const (fun config -> run config) $ config_term) in
  let info = Cmd.info "wikidata-consumer" ~doc:"Wikidata consumer application." in
  let cmd = Cmd.v info run_term in
  exit (Cmd.eval cmd)
;;
