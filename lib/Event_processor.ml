open Battle_event

let process_battle_event_json json =
  let battle_event = battle_event_from_json_string json in
  Lwt_io.printf "Processing battle: %s\n" battle_event.name
(* print_battle_event battle_event ; Lwt.return_unit *)
