open Wikidata_consumer_lib

let test_parser () =
  let battle_event_json_string =
    "{\"id\": \"event1\", \"body\": {\"id\": \"event1\", \"name\": \"Battle of Mocking \
     Forest\", \"date\": 162345.0, \"location\": \"Mocking Forest, Fantasyland\", \
     \"wikipedia_url_stub\": \"https://en.wikipedia.org/wiki/Battle_of_Mocking_Forest\", \
     \"coordinates\": \"45.0,10.0\", \"outcome\": \"Victory for the Eastern Alliance\", \
     \"image_url_stub\":  \"https://example.com/images/battle_of_mocking_forest.jpg\", \
     \"checksum\": \"checksum1\"}}"
  in
  let battle_event =
    Battle_event.battle_event_from_json_string battle_event_json_string
  in
  Alcotest.(check string) "equal" "event1" battle_event.id
;;

let test_parser_with_null () =
  let battle_event_json_string =
    "{\"id\": \"event1\", \"body\": {\"id\": \"event1\", \"name\": \"Battle of Mocking \
     Forest\", \"date\": 162345.0, \"location\": \"Mocking Forest, Fantasyland\", \
     \"wikipedia_url_stub\": \"https://en.wikipedia.org/wiki/Battle_of_Mocking_Forest\", \
     \"coordinates\": \"45.0,10.0\", \"outcome\": \"Victory for the Eastern Alliance\", \
     \"image_url_stub\": null , \"checksum\": \"checksum1\"}}"
  in
  let battle_event =
    Battle_event.battle_event_from_json_string battle_event_json_string
  in
  Alcotest.(check string) "equal" "event1" battle_event.id
;;
