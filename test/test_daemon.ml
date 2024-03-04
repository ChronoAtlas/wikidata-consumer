open Wikidata_consumer_lib

let mock_consumer_messages = ["msg1"; "msg2"; "msg3"]

let mock_consumer () : string Lwt_stream.t = Lwt_stream.of_list mock_consumer_messages

let processed_messages = ref []

let mock_processor (msg : string) : unit Lwt.t =
  processed_messages := msg :: !processed_messages ;
  Lwt.return_unit

let run_test () =
  processed_messages := [] ;
  let () = Lwt_main.run (Daemon.run_daemon mock_consumer mock_processor) in
  Alcotest.(check (list string)) "equal" mock_consumer_messages (List.rev !processed_messages)
