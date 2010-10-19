module L = LazyStream
module P = Parsec

let _ =
  assert (Some 1 = P.run (P.return 1) (L.of_string ""));  
  let char c = P.token (fun x -> if (x = c) then Some x else None) in
  let ( <|> ) = P.choose in
  let ( >> ) a b = P.bind a (fun _ -> b) in
  let p =
    (char 'a' >> char 'b')
    <|> (char 'a' >> char 'c') in
  assert (None = P.run p (L.of_string "ac"));
  let p =
    P.attempt (char 'a' >> char 'b')
    <|> (char 'a' >> char 'c')
  in
  assert (Some 'c' = P.run p (L.of_string "ac"))
