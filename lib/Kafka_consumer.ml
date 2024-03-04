open Config
open Lwt
open Kafka.Metadata


let start_partitions queue topic partitions offset =
  Lwt_list.iter_s
    (fun partition ->
      let () = Kafka.consume_start_queue queue topic partition offset in
      Lwt.return_unit )
    partitions

let consume_messages (queue : Kafka.queue) (callback : string -> unit t) =
  Kafka_lwt.consume_batch_queue ~timeout_ms:1000 ~msg_count:10 queue
  >>= Lwt_list.iter_s (function
       | Kafka.Message (_, _, _, msg, _) ->
           callback msg
       | Kafka.PartitionEnd (_, _, _) ->
           Printf.printf "End\n";
           Lwt.return_unit)
  >>= fun () -> flush stdout; Lwt.return_unit

let rec consume_loop queue config callback =
  consume_messages queue callback
  >>= fun () -> Lwt_unix.sleep (float_of_int config.sleep_interval_s)
  >>= fun () -> consume_loop queue config callback

let consume_with_config config callback =
  let consumer = Kafka.new_consumer [("metadata.broker.list", config.kafka_brokers)] in
  let topic = Kafka.new_topic consumer config.kafka_topic [] in
  let queue = Kafka.new_queue consumer in
  let metadata = Kafka.topic_metadata consumer topic in
  Lwt_main.run
    (start_partitions queue topic metadata.topic_partitions 0L
    >>= fun () ->
    consume_loop queue config callback
    >>= fun () ->
    Kafka.destroy_topic topic; Kafka.destroy_queue queue; Kafka.destroy_handler consumer; Lwt.return_unit)
