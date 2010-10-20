Require Import Coq.Lists.List.

Axiom t : Type.

Inductive parser (a : Type) : Type :=
  | ret  : a -> parser a
  | bind : forall {x}, parser x -> (x -> parser a) -> parser a.

Inductive reply (a : Type) : Type :=
  | failed   : reply a
  | matched  : a -> reply a
  | consumed : nat -> parser a -> reply a.

Fixpoint run {a : Type} (p : parser a) (x : list t) : reply a :=
  match p with
  | ret v      => matched a v
  | bind b p f => 
    match run p x with
    | failed       => failed a
    | matched m    => run (f m) x
    | consumed n q => consumed a n (bind a q f)
    end
  end.

Axiom a b c : Type.

Definition eq {a : Type} (p : parser a) (q : parser a) : Prop :=
  forall x, run p x = run q x.

Lemma left_id : forall (x : a) (f : a -> parser b),
  eq (bind _ (ret _ x) f) (f x).

Lemma right_id : forall (p : parser a),
  eq (bind _ p (ret _)) p.

Lemma assoc : forall (p : parser a) (f : a -> parser b) (g : b -> parser c),
  eq (bind _ (bind _ p f) g)
     (bind _ p (fun x => bind _ (f x) g)).

