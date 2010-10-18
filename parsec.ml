type 'a stream = 'a LazyStream.t 

type ('t, 'a) reply = 
    Fail
  | Match of 'a * 't stream
  | Parse of ('t, 'a) parser * 't stream

and ('t, 'a) parser =
    't stream -> ('t, 'a) reply

let return x s = Match (x, s)
    
let rec bind p f s =
  match p s with
    | Fail as fail  -> fail
    | Match (x, s') -> Parse (f x, s')
    | Parse (q, s') -> Parse (bind q f, s')

let choose p q s =
  match p s with
    | Fail           -> q s
    | Match _ as r   -> r
    | Parse (q', s') -> q' s'

let attempt p s =
  match p s with
    | Parse (q', s') -> q' s'
    | r              -> r

let rec run p s =
  match p s with
    | Fail          -> None
    | Match (r, _)  -> Some r
    | Parse (q, s') -> run q s'

let token f s =
  match LazyStream.next s with
    | None         -> Fail
    | Some (t, s') ->
      match f t with
        | None   -> Fail
        | Some x -> Match (x, s')
          
let ( >>= ) = bind

let ( <|> ) = choose

let rec fold1 f z p =
  p >>= fun x ->
  fold f (f z x) p 

and fold f z p =
  fold1 f z p <|> return z

let rec many1 p =
  p >>= fun x ->
  many p >>= fun xs ->
  return (x :: xs)
    
and many p =
  many1 p <|> return []

