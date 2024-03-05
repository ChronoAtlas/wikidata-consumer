open Caqti_blocking

module Q = struct
  open Caqti_request.Infix
  open Caqti_type.Std

  let create_migrations_table =
    (unit ->. unit)
    @@ {eos|
        CREATE TABLE IF NOT EXISTS migrations (
            name TEXT PRIMARY KEY,
            applied_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
        )
    |eos}
end

let ensure_migrations_table (module Db : Caqti_blocking.CONNECTION) = Db.exec Q.create_migrations_table

let upgrade uri =
  match connect (Uri.of_string uri) with
  | Error err ->
      let msg = Printf.sprintf "Abort! We could not get a connection. (err=%s)\n" (Caqti_error.show err) in
      failwith msg
  | Ok conn -> ensure_migrations_table conn
  ()
