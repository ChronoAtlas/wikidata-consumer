open Config
open Lwt
open Kafka.Metadata

let start_partitions queue topic partitions offset =
  Lwt_list.iter_s
    (fun partition ->
      let () = Kafka.consume_start_queue queue topic partition offset in
      Lwt.return_unit)
    partitions
;;

let consume_messages (queue : Kafka.queue) : string Lwt_stream.t =
  let stream, push = Lwt_stream.create () in
  let rec loop () =
    Kafka_lwt.consume_batch_queue ~timeout_ms:1000 ~msg_count:10 queue
    >>= Lwt_list.iter_s (function
      | Kafka.Message (_, _, _, msg, _) ->
        let _ =
          Lwt_io.printf
            "New message: %s...\n"
            (String.sub msg 0 (min 20 (String.length msg)))
        in
        push (Some msg);
        Lwt.return_unit
      | Kafka.PartitionEnd (_, _, _) ->
        Printf.printf "End of partition\n";
        flush stdout;
        Lwt.return_unit)
    >>= fun () -> loop ()
  in
  Lwt.async loop;
  stream
;;

let consume_with_config (config : config) : string Lwt_stream.t =
  let _ = Lwt_io.printf "Consuming from %s\n" config.kafka_brokers in
  let consumer = Kafka.new_consumer [ "metadata.broker.list", config.kafka_brokers ] in
  let topic = Kafka.new_topic consumer config.kafka_topic [] in
  let queue = Kafka.new_queue consumer in
  let metadata = Kafka.topic_metadata consumer topic in
  Lwt_main.run (start_partitions queue topic metadata.topic_partitions 0L);
  consume_messages queue
;;
