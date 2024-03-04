open Wikidata_consumer_lib
open Cmdliner

let run _config = ()
(* let curried_consume : Daemon.consumer_func = fun () -> Kafka_consumer.consume_with_config config in *)
(* let process_func : Daemon.processor_func = Event_processor.process_battle_event_json in *)
(* Lwt_main.run (Daemon.run_daemon curried_consume process_func) *)

let () =
  let config_term = Cli.build_cli_args () in
  let run_term = Term.(const (fun config -> run config) $ config_term) in
  let info = Cmd.info "wikidata-consumer" ~doc:"Wikidata consumer application." in
  let cmd = Cmd.v info run_term in
  exit (Cmd.eval cmd)
