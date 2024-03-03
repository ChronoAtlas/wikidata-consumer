open Wikidata_consumer_lib

module To_test = struct
  let add = Math.add

  let sub = Math.sub
end

let test_add () = Alcotest.(check int) "adds" 9 (To_test.add 4 5)

let test_sub () = Alcotest.(check int) "subs" 0 (To_test.sub 4 4)

let () =
  let open Alcotest in
  run "Math" [("add", [test_case "add numbers" `Quick test_add]); ("sub", [test_case "subs numbers" `Quick test_sub])]
