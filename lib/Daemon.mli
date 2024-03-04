val run_daemon :
  (unit -> string Lwt_stream.t) -> (Battle_event.battle_event -> Battle_event.battle_event) list -> unit Lwt.t
