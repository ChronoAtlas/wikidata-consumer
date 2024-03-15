open Event_processor

let run_daemon consume processors =
  let messages = consume () in
  Lwt_stream.iter_s (fun message -> process_battle_event_json message processors) messages
;;
