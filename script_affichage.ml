
open Bdd_base

(* Ce script est utilisé pour pouvoir afficher les coordonnées   *)
(* des cases ainsi que les BDD directement dans OCaml.           *)


(* Fonctions d'affichages requises pour l'intégration dans OCaml.*)

(* Fonction qui affiche une case sous la forme d'une paire       *)
(* de coordonnées <x,y>                                          *)
let afficher_case fmt case =
  Format.fprintf fmt "<%d,%d>" (Case.get_x case) (Case.get_y case);;

(* Fonctions auxiliaires pour un affichage plus lisible des BDD. *)
let afficher_atome fmt (b, case) =
  if b then Format.fprintf fmt "@ %a" afficher_case case
       else Format.fprintf fmt "@ \x1b[7m%a\x1b[0m" afficher_case case;;

let rec afficher_path fmt path =
  match path with
  | []   -> ()
  | t::q -> Format.fprintf fmt "%a%a" afficher_path q afficher_atome t;;

let rec afficher_rec path fmt t =
  match t with
  | Bot -> ()
  | Top -> Format.fprintf fmt "@,  {@[<h 2>%a@ @]}" afficher_path path
  | Node (l,v,r) -> Format.fprintf fmt "%a%a" (afficher_rec ((false, v)::path)) l (afficher_rec ((true, v)::path)) r;;

(* Fonction qui affiche un BDD sous une forme normale            *)
(* disjonctive, en parcourant les branches de l'arbre binaire    *)
(* qui partent de la racine et s'arrêtent sur Top.               *)
(* Ainsi, Bot sera affiché comme { }, Top comme { { } }.         *)
(* Chaque branche se présente horizontalement comme              *)
(* une suite de cases entre accolades. Pour chaque case c:       *)
(* Si c=Bot, alors c est affichée en inverse video.              *)
(* Si c=Top, alors c est affichée normalement.                   *)
let afficher_bdd fmt t =
  Format.fprintf fmt "@.@[<v 0>{%a@,}@]" (afficher_rec []) t;;


(* Directives d'affichage pour l'interprète Ocaml.               *)
#install_printer afficher_case;;
#install_printer afficher_bdd;;
