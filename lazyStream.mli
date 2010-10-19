(** Implements lazy lists or streams. Unlike the streams from the
    Stream module, LazyStream values have a pure interface and support
    backtracking. *)

(** Represents a lazy stream. *)
type 'a t

(** Destructures a lazy stream. *)
val next : 'a t -> ('a * 'a t) option

(** Constructs a lazy stream from a generator. *)
val from : (int -> 'a option) -> 'a t

(** Iterates over a lazy stream. *)
val iter : ('a -> unit) -> 'a t -> unit

(** Converts a list to a lazy stream. *)
val of_list : 'a list -> 'a t

(** Converts a string to a lazy character stream. *)
val of_string : string -> char t

(** Lazily reads all characters from the channel. *)
val of_channel : in_channel -> char t

(** Counts the number of elements in the stream. *)
val count : 'a t -> int

