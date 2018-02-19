open Bdd_base;;
open Case;;
open Akari_solveur;;

(*Création de case*)

let x00=make 0 0;; 
let x01=make 0 1;; 
let x02=make 0 2;;
let x03=make 0 3;;
let x04=make 0 4;;
let x10=make 1 0;; 
let x11=make 1 1;; 
let x12=make 1 2;;
let x13=make 1 3;;
let x14=make 1 4;; 
let x20=make 2 0;; 
let x21=make 2 1;; 
let x22=make 2 2;;
let x23=make 2 3;;
let x24=make 2 4;;
let x20=make 2 0;; 
let x21=make 2 1;; 
let x22=make 2 2;;
let x23=make 2 3;;
let x24=make 2 4;;
let x30=make 3 0;; 
let x31=make 3 1;; 
let x32=make 3 2;;
let x33=make 3 3;;
let x34=make 3 4;;
let x40=make 4 0;; 
let x41=make 4 1;; 
let x42=make 4 2;;
let x43=make 4 3;;
let x44=make 4 4;;

(*Resultats*)
(*
val x00 : Case.t = <0,0>
val x01 : Case.t = <0,1>
val x02 : Case.t = <0,2>
val x03 : Case.t = <0,3>
val x04 : Case.t = <0,4>
val x10 : Case.t = <1,0>
val x11 : Case.t = <1,1>
val x12 : Case.t = <1,2>
val x13 : Case.t = <1,3>
val x14 : Case.t = <1,4>
val x20 : Case.t = <2,0>
val x21 : Case.t = <2,1>
val x22 : Case.t = <2,2>
val x23 : Case.t = <2,3>
val x24 : Case.t = <2,4>
val x20 : Case.t = <2,0>
val x21 : Case.t = <2,1>
val x22 : Case.t = <2,2>
val x23 : Case.t = <2,3>
val x24 : Case.t = <2,4>
val x30 : Case.t = <3,0>
val x31 : Case.t = <3,1>
val x32 : Case.t = <3,2>
val x33 : Case.t = <3,3>
val x34 : Case.t = <3,4>
val x40 : Case.t = <4,0>
val x41 : Case.t = <4,1>
val x42 : Case.t = <4,2>
val x43 : Case.t = <4,3>
val x44 : Case.t = <4,4>

*)


(*Création de bdd*)
let bdd00=posvariable x00;;
let bdd01=posvariable x01;;
let bdd02=posvariable x02;;
let bdd10=posvariable x10;;
let bdd11=posvariable x11;;
let bdd12=posvariable x12;;
let bdd20=posvariable x20;;
let bdd21=posvariable x21;;
let bdd22=posvariable x22;;
(*Resultats*)
(*
val bdd00 : Bdd_base.bdd = 
{
  { <0,0> }
}
val bdd01 : Bdd_base.bdd = 
{
  { <0,1> }
}
val bdd02 : Bdd_base.bdd = 
{
  { <0,2> }
}
val bdd10 : Bdd_base.bdd = 
{
  { <1,0> }
}
val bdd11 : Bdd_base.bdd = 
{
  { <1,1> }
}
val bdd12 : Bdd_base.bdd = 
{
  { <1,2> }
}
val bdd20 : Bdd_base.bdd = 
{
  { <2,0> }
}
val bdd21 : Bdd_base.bdd = 
{
  { <2,1> }
}
val bdd22 : Bdd_base.bdd = 
{
  { <2,2> }
}

*)

(*Tests de est_bdd*)
est_bdd bdd00;;
est_bdd bdd21;;
est_bdd top;;

(*Resultats*)
(*
- : bool = true
- : bool = true
- : bool = true
*)

(*Tests de conjonction*)
let conj1 = conjonction bdd01 bdd10;;
est_bdd conj1;;
let conj2 = conjonction conj1 bdd22;;
est_bdd conj2;;
(*Resultats*)
(*

val conj1 : Bdd_base.bdd = 
{
  { <1,0> <0,1> }
}

- : bool = true

val conj2 : Bdd_base.bdd = 
{
  { <1,0> <0,1> <2,2> }
}

- : bool = true
*)

(*Tests de combinaisons*)
let comb1 = combinaisons 5 [x00;x11;x22;x10;x21;x01];;
est_bdd comb1;;

let comb2 = combinaisons 10 [x00];;
est_bdd comb2;;

let comb3 = combinaisons 0 [x00;x11;x22;x10;x21;x01];;
est_bdd comb3;;

(*Resultats*)
(*

val comb1 : Bdd_base.bdd = 
{
  { <0,0> <1,0> <0,1> <1,1> <2,1> <2,2> }
  { <0,0> <1,0> <0,1> <1,1> <2,1> <2,2> }
  { <0,0> <1,0> <0,1> <1,1> <2,1> <2,2> }
  { <0,0> <1,0> <0,1> <1,1> <2,1> <2,2> }
  { <0,0> <1,0> <0,1> <1,1> <2,1> <2,2> }
  { <0,0> <1,0> <0,1> <1,1> <2,1> <2,2> }
}

- : bool = true

val comb2 : Bdd_base.bdd = 
{
}

- : bool = true

val comb3 : Bdd_base.bdd = 
{
  { <0,0> <1,0> <0,1> <1,1> <2,1> <2,2> }
}

- : bool = true

*)

(*Définition d'une grille de test*)

let grille_test case =
	match (Case.get_x case),(Case.get_y case) with
	|0,0 ->Vide 
	|0,1 ->Vide
	|0,2 ->Vide
	|0,3 ->Vide
	|0,4 ->Vide
	|1,0 ->Vide
	|1,1 ->Noir (Some 4)
	|1,2 ->Vide
	|1,3 ->Noir None
	|1,4 ->Vide
	|2,0 ->Vide
	|2,1 ->Vide
	|2,2 ->Vide
	|2,3 ->Noir (Some 2)
	|2,4 ->Vide
	|3,0 ->Noir (Some 0)
	|3,1 ->Vide 
	|3,2 ->Noir None
	|3,3 ->Vide
	|3,4 ->Vide
	|4,0 ->Vide 
	|4,1 ->Vide
	|4,2 ->Vide 
	|4,3 ->Vide
	|4,4 ->Vide
	|_-> failwith "error";;
	
	(*Nouvelle grille de test*)

let grille2_test case=
  match (get_x case),(get_y case) with
        |0,0 -> Vide
        |0,1 -> Vide
        |0,2 -> Vide
        |1,0 -> Noir(None)
        |1,1 -> Vide
        |1,2 -> Vide
        |2,0 -> Vide
        |2,1 -> Noir (None)
        |2,2 -> Vide
        |_ -> failwith " error " ;;

(*Tests de adjacentes*)
let adj10 = adjacentes 5 x10;;
let adj00 = adjacentes 5 x00;;
 
(*Resultats*)
(*
val adj10 : Case.t list = [<0,0>; <2,0>; <1,1>]
val adj00 : Case.t list = [<1,0>; <0,1>]
*)

(*Tests de voisines_visibles*)
let voisi21 = voisines_visibles 5 grille_test x21;;	
let voisi11 = voisines_visibles 5 grille_test x11;;
let voisi02 = voisines_visibles 5 grille_test x02;;

(*Resultats*)
(*
val voisi21 : Case.t list = [<0,1>; <4,1>; <3,1>; <2,0>; <2,4>; <2,2>]
val voisi11 : Case.t list = [<0,1>; <4,1>; <3,1>; <2,1>; <1,0>; <1,4>; <1,2>]
val voisi02 : Case.t list = [<4,2>; <2,2>; <1,2>; <0,0>; <0,1>; <0,4>; <0,3>]
*)

(*Tests de disjonctions*)

let disj1= disjonction bdd10 bdd01;;
est_bdd disj1;;

let disj2 = disjonction disj1 bot;;
est_bdd disj2;;

let disj3 = disjonction disj1 bdd11;;
est_bdd disj3;;
(*Resultats*)
(*
val disj1 : Bdd_base.bdd = 
{
  { <1,0> <0,1> }
  { <1,0> }
}

- : bool = true

val disj2 : Bdd_base.bdd = 
{
  { <1,0> <0,1> }
  { <1,0> }
}

- : bool = true

val disj3 : Bdd_base.bdd = 
{
  { <1,0> <0,1> <1,1> }
  { <1,0> <0,1> }
  { <1,0> }
}

- : bool = true
*)

(*Tests de colonnes visibles et lignes visibles*)
let colvis10 = colonnes_visible 5 grille_test x10;;
let colvis00 = colonnes_visible 5 grille_test x00;;
let ligvis21 = lignes_visible 5 grille_test x21;;
let ligvis02 = lignes_visible 5 grille_test x02;;


(*Resultats*)
(*
val colvis10 : Case.t list = [<1,4>; <1,2>]
val colvis00 : Case.t list = [<0,4>; <0,3>; <0,2>; <0,1>]
val ligvis21 : Case.t list = [<0,1>; <4,1>; <3,1>]
val ligvis02 : Case.t list = [<4,2>; <2,2>; <1,2>]
*)

(*Tests de correction*)
let cor00=correction 3 grille2_test x00;;
est_bdd cor00;;

let cor22=correction 3 grille2_test x22;;
est_bdd cor22;;

let cor11=correction 3 grille2_test x11;;
est_bdd cor11;;

(*Resultats*)
(*
val cor00 : Bdd_base.bdd = 
{
  { <0,0> <1,0> <2,0> <4,0> <0,1> <0,2> <0,3> <0,4> }
  { <0,0> <1,0> <2,0> <4,0> <0,1> <0,2> <0,3> <0,4> }
  { <0,0> <1,0> <2,0> <4,0> <0,1> <0,2> <0,3> <0,4> }
  { <0,0> <1,0> <2,0> <4,0> <0,1> <0,2> <0,3> <0,4> }
  { <0,0> <1,0> <2,0> <4,0> <0,1> <0,2> <0,3> }
  { <0,0> <1,0> <2,0> <4,0> <0,1> <0,2> <0,3> <0,4> }
  { <0,0> <1,0> <2,0> <4,0> <0,1> <0,2> <0,3> <0,4> }
  { <0,0> <1,0> <2,0> <4,0> <0,1> <0,2> <0,3> <0,4> }
  { <0,0> <1,0> <2,0> <4,0> <0,1> <0,2> <0,3> }
  { <0,0> <1,0> <2,0> <4,0> <0,1> <0,2> <0,3> <0,4> }
  { <0,0> <1,0> <2,0> <4,0> <0,1> <0,2> <0,3> <0,4> }
  { <0,0> <1,0> <2,0> <4,0> <0,1> <0,2> <0,3> <0,4> }
  { <0,0> <1,0> <2,0> <4,0> <0,1> <0,2> <0,3> }
  { <0,0> <1,0> <2,0> <4,0> <0,1> <0,2> <0,3> <0,4> }
  { <0,0> <1,0> <2,0> <4,0> <0,1> <0,2> <0,3> <0,4> }
  { <0,0> <1,0> <2,0> <4,0> <0,1> <0,2> <0,3> <0,4> }
  { <0,0> <1,0> <2,0> <4,0> <0,1> <0,2> <0,3> <0,4> }
}

- : bool = true

val cor22 : Bdd_base.bdd = 
{
  { <2,0> <2,1> <0,2> <1,2> <2,2> <4,2> <2,4> }
  { <2,0> <2,1> <0,2> <1,2> <2,2> <4,2> }
  { <2,0> <2,1> <0,2> <1,2> <2,2> <4,2> <2,4> }
  { <2,0> <2,1> <0,2> <1,2> <2,2> <4,2> }
  { <2,0> <2,1> <0,2> <1,2> <2,2> <4,2> }
  { <2,0> <2,1> <0,2> <1,2> <2,2> <2,4> }
  { <2,0> <2,1> <0,2> <1,2> <2,2> <4,2> <2,4> }
  { <2,0> <2,1> <0,2> <1,2> <2,2> <4,2> <2,4> }
  { <2,0> <2,1> <0,2> <1,2> <2,2> <2,4> }
  { <2,0> <2,1> <0,2> <1,2> <2,2> <4,2> <2,4> }
  { <2,0> <2,1> <0,2> <1,2> <2,2> <4,2> <2,4> }
}

- : bool = true

val cor11 : Bdd_base.bdd = 
{
  { <1,0> <0,1> <1,1> <2,1> <1,2> }
}
- : bool = true

*)

	
(*Tests des différentes fonctions sur les configurations*)
(*Test de initialisation*)
let conf1= initialisation 3 grille2_test;;

(*
val conf1 : Akari_solveur.configuration = <abstr>
*)

(*Tests de information*)
let info1 = information conf1;;

(*
val info1 : Case.t option = Some <0,0>
*)

(*Tests de appartient*)

appartient x00 [];;
appartient x00 [x11;x22;x10];;
appartient x00 [x11;x00;x22];;

(*
- : bool = false
- : bool = false
- : bool = true
*)

(*Tests de remove*)

remove x11 [];;
remove x11 [x00;x22;x10];;
remove x11 [x11;x22;x10];;
remove x11 [x12;x11;x10];;
(*
- : Case.t list = []
- : Case.t list = [<0,0>; <2,2>; <1,0>]
- : Case.t list = [<2,2>; <1,0>]
- : Case.t list = [<1,2>; <1,0>]
*)

(*Tests de allume*)
let bdallu1 = allume [];;
est_bdd bdallu1;;

let bdallu2 = allume [x12];;
est_bdd bdallu2;;

let bdallu3 = allume [x11;x00;x21;x02];;
est_bdd bdallu3;;
(*Resultats*)
(*

val bdallu1 : Bdd_base.bdd = 
{
  { }
}

- : bool = true

val bdallu2 : Bdd_base.bdd = 
{
  { <1,2> }
}

- : bool = true

val bdallu3 : Bdd_base.bdd = 
{
  { <0,0> <1,1> <2,1> <0,2> }
}

- : bool = true
*)

(*Tests de mise_a_jour et d'impossible*)

let conf2 = mise_a_jour x00 conf1;;
impossible conf2;;

let conf3 = mise_a_jour x01 conf1;;
impossible conf3;;

let conf4 = mise_a_jour x22 conf1;;
impossible conf4;;
