type config = {
  kafka_brokers : string;
  kafka_topic : string;
  postgres_conn_string : string;
  sleep_interval_s : int;
}

let config kafka_brokers kafka_topic postgres_conn_string sleep_interval_s =
  { kafka_brokers; kafka_topic; postgres_conn_string; sleep_interval_s }
