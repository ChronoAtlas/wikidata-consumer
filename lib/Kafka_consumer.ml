open Config
open Lwt
open Kafka.Metadata

(* Start consuming from specified partitions *)
let start_partitions queue topic partitions offset =
  Lwt_list.iter_s
    (fun partition ->
      let () = Kafka.consume_start_queue queue topic partition offset in
      Lwt.return_unit )
    partitions

(* Consume messages and push them into a stream *)
let consume_messages (queue : Kafka.queue) : string Lwt_stream.t =
  let stream, push = Lwt_stream.create () in
  let rec loop () =
    Kafka_lwt.consume_batch_queue ~timeout_ms:1000 ~msg_count:10 queue
    >>= Lwt_list.iter_s (function
          | Kafka.Message (_, _, _, msg, _) ->
              push (Some msg) ; (* Push each message into the stream *)
                                Lwt.return_unit
          | Kafka.PartitionEnd (_, _, _) -> Printf.printf "End of partition\n" ; flush stdout ; Lwt.return_unit )
    >>= fun () -> loop ()
  in
  Lwt.async loop ; (* Start the loop in a non-blocking manner *)
                   stream

(* Main function to setup consumer and return a stream of messages *)
let consume_with_config (config : config) : string Lwt_stream.t =
  let consumer = Kafka.new_consumer [("metadata.broker.list", config.kafka_brokers)] in
  let topic = Kafka.new_topic consumer config.kafka_topic [] in
  let queue = Kafka.new_queue consumer in
  let metadata = Kafka.topic_metadata consumer topic in
  Lwt_main.run (start_partitions queue topic metadata.topic_partitions 0L) ;
  (* Return the stream for further processing *)
  consume_messages queue

(* Clean-up resources - can be called after stream consumption is done or on program exit *)
(* let cleanup (consumer : Kafka.consumer) (topic : Kafka.topic) (queue : Kafka.queue) : unit = *)
(*   Kafka.destroy_topic topic; *)
(*   Kafka.destroy_queue queue; *)
(*   Kafka.destroy_handler consumer; *)
