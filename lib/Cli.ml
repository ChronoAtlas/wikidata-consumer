open Cmdliner
open Config

let make_config kafka_brokers kafka_topic mongo_db_uri sleep_interval_s =
  { kafka_brokers; kafka_topic; mongo_db_uri; sleep_interval_s }
;;

let build_cli_args () =
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
      required & opt (some string) None & info [ "kafka-topic" ] ~docv:"KAFKA_TOPIC" ~doc)
  in
  let mongo_db_uri =
    let doc = "MongoDB URI." in
    Arg.(
      required & opt (some string) None & info [ "mongodb-uri" ] ~docv:"MONGO_DB_URI" ~doc)
  in
  let sleep_interval_s =
    let doc = "Sleep interval in seconds between fetches from Kafka." in
    Arg.(
      required
      & opt (some int) None
      & info [ "sleep-interval" ] ~docv:"SLEEP_INTERVAL_S" ~doc)
  in
  Term.(const make_config $ kafka_brokers $ kafka_topic $ mongo_db_uri $ sleep_interval_s)
;;
