open Wikidata_consumer_lib

let mock_consumer_messages =
  [ "{\"id\": \"event1\", \"body\": {\"id\": \"event1\", \"name\": \"Battle of Mocking \
     Forest\", \"date\": 162345.0, \"location\": \"Mocking Forest, Fantasyland\", \
     \"wikipedia_url_stub\": \"https://en.wikipedia.org/wiki/Battle_of_Mocking_Forest\", \
     \"coordinates\": \"45.0,10.0\", \"outcome\": \"Victory for the Eastern Alliance\", \
     \"image_url_stub\":  \"https://example.com/images/battle_of_mocking_forest.jpg\", \
     \"checksum\": \"checksum1\"}}"
  ; "{\"id\": \"event2\", \"body\": {\"id\": \"event2\", \"name\": \"Battle of Mocking \
     Forest\", \"date\": 162345.0, \"location\": \"Mocking Forest, Fantasyland\", \
     \"wikipedia_url_stub\": \"https://en.wikipedia.org/wiki/Battle_of_Mocking_Forest\", \
     \"coordinates\": \"45.0,10.0\", \"outcome\": \"Victory for the Eastern Alliance\", \
     \"image_url_stub\":  \"https://example.com/images/battle_of_mocking_forest.jpg\", \
     \"checksum\": \"checksum1\"}}"
  ; "{\"id\": \"event3\", \"body\": {\"id\": \"event3\", \"name\": \"Battle of Mocking \
     Forest\", \"date\": 162345.0, \"location\": \"Mocking Forest, Fantasyland\", \
     \"wikipedia_url_stub\": \"https://en.wikipedia.org/wiki/Battle_of_Mocking_Forest\", \
     \"coordinates\": \"45.0,10.0\", \"outcome\": \"Victory for the Eastern Alliance\", \
     \"image_url_stub\":  \"https://example.com/images/battle_of_mocking_forest.jpg\", \
     \"checksum\": \"checksum1\"}}"
  ]
;;

let processed_messages = ref []
let mock_consumer () : string Lwt_stream.t = Lwt_stream.of_list mock_consumer_messages
let mock_empty_consumer () : string Lwt_stream.t = Lwt_stream.of_list []

let mock_processor event : Battle_event.battle_event =
  processed_messages := event :: !processed_messages;
  event
;;

let mock_empty_processor event : Battle_event.battle_event = event

let test_run () =
  processed_messages := [];
  let () = Lwt_main.run (Daemon.run_daemon mock_consumer [ mock_processor ]) in
  let processed_ids =
    List.map (fun (event : Battle_event.battle_event) -> event.id) !processed_messages
  in
  let expected_ids = [ "event1"; "event2"; "event3" ] in
  Alcotest.(check (list string)) "equal" expected_ids (List.rev processed_ids)
;;

let test_run_multiple_processors () =
  processed_messages := [];
  let () =
    Lwt_main.run
      (Daemon.run_daemon
         mock_consumer
         [ mock_processor; mock_processor; mock_empty_processor ])
  in
  let processed_ids =
    List.map (fun (event : Battle_event.battle_event) -> event.id) !processed_messages
  in
  let expected_ids = [ "event1"; "event1"; "event2"; "event2"; "event3"; "event3" ] in
  Alcotest.(check (list string)) "equal" expected_ids (List.rev processed_ids)
;;

let test_run_empty () =
  processed_messages := [];
  let () = Lwt_main.run (Daemon.run_daemon mock_empty_consumer [ mock_processor ]) in
  let processed_ids =
    List.map (fun (event : Battle_event.battle_event) -> event.id) !processed_messages
  in
  Alcotest.(check (list string)) "equal" processed_ids []
;;
