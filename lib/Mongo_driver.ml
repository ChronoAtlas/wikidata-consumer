open Ctypes
open Foreign

let initialized = ref false
let mongoc_init = foreign "mongoc_init" (void @-> returning void)
let mongoc_cleanup = foreign "mongoc_cleanup" (void @-> returning void)
let mongoc_client_destroy = foreign "mongoc_client_destroy" (ptr void @-> returning void)

let mongoc_client_new_from_uri =
  foreign "mongoc_client_new_from_uri" (string @-> returning (ptr void))
;;

let mongoc_connect uri =
  if not !initialized
  then (
    mongoc_init ();
    initialized := true);
  let client_ptr = mongoc_client_new_from_uri uri in
  if Ctypes.is_null client_ptr
  then (
    Printf.eprintf "Connection could not be established to %s\n" uri;
    failwith "Unable to connect to MongoDB")
  else (
    Printf.printf "Connected to %s\n" uri;
    client_ptr)
;;
