open Yojson.Basic.Util

type battle_event =
  { name: string
  ; date: float
  ; location: string
  ; wikipedia_url_stub: string
  ; coordinates: string option
  ; outcome: string option
  ; image_url_stub: string option
  ; checksum: string }

let battle_event_from_json_string json_string =
  let json = Yojson.Basic.from_string json_string in
  let body_json = json |> member "body" in
  ( { name= body_json |> member "name" |> to_string
    ; date= body_json |> member "date" |> to_float
    ; location= body_json |> member "location" |> to_string
    ; wikipedia_url_stub= body_json |> member "wikipedia_url_stub" |> to_string
    ; coordinates= body_json |> member "coordinates" |> to_option to_string
    ; outcome= body_json |> member "outcome" |> to_option to_string
    ; image_url_stub= body_json |> member "image_url_stub" |> to_option to_string
    ; checksum= body_json |> member "checksum" |> to_string }
    : battle_event )

let print_battle_event message =
  Printf.printf "%s\n" message.name ;
  Printf.printf "%f\n" message.date ;
  Printf.printf "%s\n" message.location ;
  Printf.printf "%s\n" message.wikipedia_url_stub ;
  ( match message.coordinates with
  | Some coord -> Printf.printf "Coordinates: %s\n" coord
  | None -> Printf.printf "Coordinates: None\n" ) ;
  ( match message.outcome with
  | Some outcome -> Printf.printf "Outcome: %s\n" outcome
  | None -> Printf.printf "Outcome: None\n" ) ;
  ( match message.image_url_stub with
  | Some url -> Printf.printf "Image URL Stub: %s\n" url
  | None -> Printf.printf "Image URL Stub: None\n" ) ;
  Printf.printf "%s\n" message.checksum
