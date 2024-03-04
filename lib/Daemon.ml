type message_stream = string Lwt_stream.t

type processor_func = string -> unit Lwt.t

type consumer_func = unit -> message_stream

let run_daemon (consume : consumer_func) (process : processor_func) : unit Lwt.t =
  let messages = consume () in
  Lwt_stream.iter_s process messages
