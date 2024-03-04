open Battle_event
open Lwt

let process_battle_event_json json =
  let battle_event = battle_event_from_json_string json in
  print_battle_event battle_event;
  return ()

