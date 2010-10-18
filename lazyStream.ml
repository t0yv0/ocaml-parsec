type 'a t =
    Nil
  | Cons of 'a * 'a t
  | Delay of (unit -> 'a t)
  | Ref of ('a t) ref

let from (f : int -> 'a option) : 'a t =
  let rec gen n =
    let rec compute () =
      let s =
        match f n with
          | None   -> Nil
          | Some x -> Cons (x, gen (n + 1)) in
      cell := s;
      s
    and cell = ref (Delay compute) in
    Ref cell in
  gen 0
      
let rec iter (f : 'a -> unit) (s : 'a t) =
  match s with
    | Nil           -> ()
    | Cons (x, xs)  -> f x; iter f xs
    | Delay compute -> iter f (compute ())
    | Ref cell      -> iter f !cell
  
let rec of_list (a : 'a list) =
  match a with
    | []      -> Nil
    | x :: xs -> Cons (x, of_list xs)

let rec of_string (a : string) =
  let k = String.length a in
  let rec gen n =
    if n < k then
      Cons (String.get a n, gen (n + 1))
    else
      Nil in
  gen 0
    
let rec of_channel chan =
  from (fun _ -> 
    try Some (input_char chan) with
      | End_of_file -> None)

let count s =
  let rec c n s =
    match s with
      | Nil -> n
      | Cons (_, s) -> c (n + 1) s
      | Delay compute -> c n (compute ())
      | Ref cell -> c n !cell in
  c  0 s

let rec next s =
  match s with
    | Nil           -> None
    | Cons (x, s')  -> Some (x, s')
    | Delay compute -> next (compute ())
    | Ref cell      -> next !cell
