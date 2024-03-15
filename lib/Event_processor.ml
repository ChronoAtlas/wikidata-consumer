let process_battle_event_json json processors =
  let battle_event = Battle_event.battle_event_from_json_string json in
  let _ = List.fold_left (fun e p -> p e) battle_event processors in
  Lwt.return_unit
;;
