open Battle_event
open Config

let processor_curried config event : battle_event =
  let _ =
    Lwt_io.printf "Persisting battle event %s to %s\n" event.id config.mongo_db_uri
  in
  event
;;
