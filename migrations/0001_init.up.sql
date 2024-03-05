CREATE TABLE IF NOT EXISTS battle_events (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    date DOUBLE PRECISION NOT NULL, -- float in OCaml corresponds to double precision in PostgreSQL
    location TEXT NOT NULL,
    wikipedia_url_stub TEXT NOT NULL,
    coordinates TEXT, -- Optional in OCaml, so it can be NULL in the database
    outcome TEXT, -- Optional in OCaml, so it can be NULL in the database
    image_url_stub TEXT, -- Optional in OCaml, so it can be NULL in the database
    checksum TEXT NOT NULL
);
