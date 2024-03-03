open Yojson.Basic.Util

type battle_event = {
  name : string;
  date : float;
  location : string;
  wikipedia_url_stub : string;
  coordinates : string option;
  outcome : string option;
  image_url_stub : string option;
  checksum : string;
}

let kafka_message_from_json_string json_string =
  let json = Yojson.Basic.from_string json_string in
  let body_json = json |> member "body" in
  ({
    name = body_json |> member "name" |> to_string;
    date = body_json |> member "date" |> to_float;
    location = body_json |> member "location" |> to_string;
    wikipedia_url_stub = body_json |> member "wikipedia_url_stub" |> to_string;
    coordinates = body_json |> member "coordinates" |> to_option to_string;
    outcome = body_json |> member "outcome" |> to_option to_string;
    image_url_stub = body_json |> member "image_url_stub" |> to_option to_string;
    checksum = body_json |> member "checksum" |> to_string;
  } : battle_event)
