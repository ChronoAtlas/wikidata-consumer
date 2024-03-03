type t = {
  kafka_brokers : string;
  kafka_topic : string;
  postgres_conn_string : string;
  sleep_interval : int; (* In seconds *)
}

let parse_args () =
  (* Use Cmdliner to parse CLI arguments *)
  (* Example return *)
  {
    kafka_brokers = "localhost:9092";
    kafka_topic = "battle_events";
    postgres_conn_string =
      "host=localhost dbname=battle_events user=postgres password=secret";
    sleep_interval = 5;
  }
