type battle_event =
  { name: string
  ; date: float
  ; location: string
  ; wikipedia_url_stub: string
  ; coordinates: string option
  ; outcome: string option
  ; image_url_stub: string option
  ; checksum: string }

val battle_event_from_json_string : string -> battle_event

val print_battle_event : battle_event -> unit
