open Cmdliner
open Lwt
open Kafka.Metadata

type config = {
  kafka_brokers : string;
  kafka_topic : string;
  postgres_conn_string : string;
  sleep_interval_s : int;
}

let make_config kafka_brokers kafka_topic postgres_conn_string sleep_interval_s
    =
  { kafka_brokers; kafka_topic; postgres_conn_string; sleep_interval_s }

let print_msg = function
  | Kafka.Message (topic, partition, offset, msg, None) ->
      Lwt_io.printf "%s,%d,%Ld::%s\n%!" (Kafka.topic_name topic) partition
        offset msg
  | Kafka.Message (topic, partition, offset, msg, Some key) ->
      Lwt_io.printf "%s,%d,%Ld:%s:%s\n%!" (Kafka.topic_name topic) partition
        offset key msg
  | Kafka.PartitionEnd (topic, partition, offset) ->
      Lwt_io.printf "%s,%d,%Ld (EOP)\n%!" (Kafka.topic_name topic) partition
        offset

let run_with_config config =
  Printf.printf
    "Using config: brokers=%s, topic=%s, postgres_conn_string=%s, interval=%d\n"
    config.kafka_brokers config.kafka_topic config.postgres_conn_string
    config.sleep_interval_s;
  flush stdout;
  let consumer =
    Kafka.new_consumer [ ("metadata.broker.list", config.kafka_brokers) ]
  in
  let topic = Kafka.new_topic consumer config.kafka_topic [] in
  let queue = Kafka.new_queue consumer in
  let offset = 0L in
  let timeout_ms = 1000 in
  let interval_ms = 1000 in
  let msg_count = 10 in
  let partitions = (Kafka.topic_metadata consumer topic).topic_partitions in
  let start () =
    List.iter
      (fun partition -> Kafka.consume_start_queue queue topic partition offset)
      partitions
    |> return
  in
  let rec loop () =
    Kafka_lwt.consume_batch_queue ~timeout_ms ~msg_count queue
    >>= Lwt_list.iter_s print_msg
    >>= fun () -> Lwt_unix.sleep (float_of_int interval_ms /. 1000.0) >>= loop
  in
  let term () =
    Kafka.destroy_topic topic;
    Kafka.destroy_queue queue;
    Kafka.destroy_handler consumer;
    return ()
  in
  Lwt_main.run (start () >>= loop >>= term)

let () =
  let kafka_brokers =
    let doc = "Kafka brokers as a comma-separated list." in
    Arg.(
      required
      & opt (some string) None
      & info [ "kafka-brokers" ] ~docv:"KAFKA_BROKERS" ~doc)
  in
  let kafka_topic =
    let doc = "Kafka topic to consume from." in
    Arg.(
      required
      & opt (some string) None
      & info [ "kafka-topic" ] ~docv:"KAFKA_TOPIC" ~doc)
  in
  let postgres_conn_string =
    let doc = "PostgreSQL connection string." in
    Arg.(
      required
      & opt (some string) None
      & info [ "postgres-conn-string" ] ~docv:"POSTGRES_CONN_STRING" ~doc)
  in
  let sleep_interval_s =
    let doc = "Sleep interval in seconds between fetches from Kafka." in
    Arg.(
      required
      & opt (some int) None
      & info [ "sleep-interval" ] ~docv:"SLEEP_INTERVAL_S" ~doc)
  in

  let config_term =
    Term.(
      const make_config $ kafka_brokers $ kafka_topic $ postgres_conn_string
      $ sleep_interval_s)
  in

  let run_term = Term.(const run_with_config $ config_term) in

  let info = Cmd.info "wikidata-consumer" ~doc:"Wikidata consumer." in
  let cmd = Cmd.v info run_term in

  exit (Cmd.eval cmd)
