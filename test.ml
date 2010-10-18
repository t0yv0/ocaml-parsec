let stdin_stream = LazyStream.of_channel stdin
let sample_stream = LazyStream.of_string "acd"

open Parsec

let char c = token (fun x ->
  if (x = c) then Some x else None)

let ( <|> ) = choose
let ( >> ) a b = bind a (fun _ -> b)

let p = 
  attempt (char 'a' >> char 'b')
  <|> (char 'a' >> char 'c')

let sumP () = fold ( + ) 0 (token (fun _ -> Some 1))
let r       = run p sample_stream

let _ =
  match r with
    | None   -> Printf.printf "NO\n"
    | Some n -> Printf.printf "YES %c\n" n
  


  
