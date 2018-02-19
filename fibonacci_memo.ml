
(* Version classique de la suite de Fibonacci.                              *)

(* Une fonction en style récursif direct.                                   *)
let rec fib n =
  if n < 2 then n else fib (n-1) + fib (n-2);;

(* Test: le résultat est calculé en une dizaine de secondes.                *)
fib 42;;



(* Version memoizee de la suite de Fibonacci.                               *)

(* Création d'une table qui sera associée uniquement à la fonction fib.     *)
let fib_table = Memo.create ();;

(* Deux fonctions mutuellement récursives.                                  *)
(* La fonction principale est la version memoizee fib qui appelle fib_code. *)
(* fib_code est simplement le code de la fonction fibonacci d'origine.      *)
let rec fib_code n =
  if n < 2 then n else fib (n-1) + fib (n-2)

(* Fonction principale résultat de la memoization de la fonction fib_code   *)
(* dans la table fib_table.                                                 *)
and fib n = Memo.apply fib_table fib_code n;;

(* Test: le résultat est immédiat.                                          *)
fib 42;;
