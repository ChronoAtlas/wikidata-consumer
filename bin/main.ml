open Wikidata_consumer_lib
open Cmdliner

let run_with_config_and_process_messages config =
  Kafka_consumer.consume_with_config config Event_processor.process_battle_event_json

let () =
  let config_term = Cli.build_cli_args () in
  let run_term = Term.(const run_with_config_and_process_messages $ config_term) in
  let info = Cmd.info "wikidata-consumer" ~doc:"Wikidata consumer application." in
  let cmd = Cmd.v info run_term in
  exit (Cmd.eval cmd)
