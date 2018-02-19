open Bdd_base;;
open Case;;
open Akari_solveur;;

let grille3 case=
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

let conf1 = initialisation 3 grille3;;
le_bdd conf1;;
