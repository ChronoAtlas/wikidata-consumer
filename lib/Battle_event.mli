type battle_event =
  { id : string
  ; name : string
  ; date : float
  ; location : string
  ; wikipedia_url_stub : string
  ; coordinates : string option
  ; outcome : string option
  ; image_url_stub : string option
  ; checksum : string
  }

val battle_event_from_json_string : string -> battle_event
