type ('t, 'a) parser

type 't stream = 't LazyStream.t

val return : 'a -> ('t, 'a) parser

val bind : ('t, 'a) parser -> ('a -> ('t, 'b) parser) -> ('t, 'b) parser

val choose : ('t, 'a) parser -> ('t, 'a) parser -> ('t, 'a) parser

val attempt : ('t, 'a) parser -> ('t, 'a) parser

val run  : ('t, 'a) parser -> 't stream -> 'a option

val token : ('t -> 'a option) -> ('t, 'a) parser

val many : ('t, 'a) parser -> ('t, 'a list) parser

val many1 : ('t, 'a) parser -> ('t, 'a list) parser

val fold : ('s -> 'a -> 's) -> 's -> ('t, 'a) parser -> ('t, 's) parser
val fold1 : ('s -> 'a -> 's) -> 's -> ('t, 'a) parser -> ('t, 's) parser
