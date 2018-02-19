
(* Le type abstrait des cases du jeu akari.                                  *)
(* Permet de représenter efficacement des couples de valeurs entières        *)
(* (abscisse, ordonnée) comprises chacune entre 0 et 255.                    *)
type t;;


(* Le type du contenu des cases.                                             *)
(* Une case contient une lampe ou non.                                       *)
type contenu =
| Vide
| Lampe;;


(* Création d'une case à l'aide de ses coordonnées.                          *)
(* Paramètres:                                                               *)
(* - une abscisse, entier entre 0 et 255                                     *)
(* - une ordonnée, entier entre 0 et 255                                     *)
(* Résultat:                                                                 *)
(* - la case correspondante aux coordonnées fournies                         *)
(* Erreur:                                                                   *)
(* - exception levée si l'abscisse ou l'ordonnée ne sont pas                 *)
(*   entre 0 et 255                                                          *)
val make : int -> int -> t;;

(* Création d'une case aux coordonnées aléatoires dans une grille carrée.    *)
(* Paramètres:                                                               *)
(* - une taille de grille, entier entre 0 et 255                             *)
(* Résultat:                                                                 *)
(* - une case dont les coordonnées sont comprises entre 0 et taille-1        *)
(* Erreur:                                                                   *)
(* - exception levée si la taille n'est pas entre 0 et 255                   *)
val random : int -> t;;

(* Coordonnée en x d'une case.                                               *)
(* Paramètre:                                                                *)
(* - une case                                                                *)
(* Résultat:                                                                 *)
(* - un entier représentant l'abscisse de la case, entre 0 et 255            *)
val get_x : t -> int;;

(* Coordonnée en y d'une case.                                               *)
(* Paramètre:                                                                *)
(* - une case                                                                *)
(* Résultat:                                                                 *)
(* - un entier représentant l'ordonnée de la case, entre 0 et 255            *)
val get_y : t -> int;;

(* Fonction calculant la liste de toutes les cases d'une ligne donnée,       *)
(* dans une grille carrée.                                                   *)
(* Paramètres:                                                               *)
(* - la taille de la grille, entier positif.                                 *)
(* - l'indice i de la ligne voulue, compté à partir de 0.                    *)
(* Résultat:                                                                 *)
(* - la liste triée par ordre (générique) croissant de toutes les cases      *)
(*   composant la ligne i                                                    *)
val ligne : int -> int -> t list;;

(* Fonction calculant la liste de toutes les lignes d'une grille carrée.     *)
(* Paramètre:                                                                *)
(* - la taille de la grille, entier positif.                                 *)
(* Résultat:                                                                 *)
(* - la liste triée par ordre (générique) croissant de toutes les lignes     *)
(*   de la grille carrée                                                     *)
val lignes : int -> t list list;;

(* Fonction calculant la liste de toutes les cases d'une colonne donnée,     *)
(* dans une grille carrée.                                                   *)
(* Paramètres:                                                               *)
(* - la taille de la grille, entier positif.                                 *)
(* - l'indice i de la colonne voulue, compté à partir de 0.                  *)
(* Résultat:                                                                 *)
(* - la liste triée par ordre (générique) croissant de toutes les cases      *)
(*   composant la colonne i                                                  *)
val colonne : int -> int -> t list;;

(* Fonction calculant la liste de toutes les colonnes d'une grille carrée.   *)
(* Paramètre:                                                                *)
(* - la taille de la grille, entier positif.                                 *)
(* Résultat:                                                                 *)
(* - la liste triée par ordre (générique) croissant de toutes les colonnes   *)
(*   de la grille carrée                                                     *)
val colonnes : int -> t list list;;

(* Fonction calculant la liste de toutes les cases sur la même ligne et      *)
(* à gauche d'une case donnée, dans une grille carrée.                       *)
(* Paramètres:                                                               *)
(* - la taille de la grille, entier positif.                                 *)
(* - la case (i, j) choisie.                                                 *)
(* Résultat:                                                                 *)
(* - la liste triée par éloignement croissant de toutes les cases à gauche   *)
(*   de la case (i, j), i.e. [(i-1, j); ...; (0, j)]                         *)
val gauche : int -> t -> t list;;

(* Fonction calculant la liste de toutes les cases sur la même ligne et      *)
(* à droite d'une case donnée, dans une grille carrée.                       *)
(* Paramètres:                                                               *)
(* - la taille de la grille, entier positif.                                 *)
(* - la case (i, j) choisie.                                                 *)
(* Résultat:                                                                 *)
(* - la liste triée par éloignement croissant de toutes les cases à droite   *)
(*   de la case (i, j), i.e. [(i+1, j); ...; (t-1, j)]                       *)
val droite : int -> t -> t list;;

(* Fonction calculant la liste de toutes les cases sur la même colonne et    *)
(* au dessus d'une case donnée, dans une grille carrée.                      *)
(* Paramètres:                                                               *)
(* - la taille de la grille, entier positif.                                 *)
(* - la case (i, j) choisie.                                                 *)
(* Résultat:                                                                 *)
(* - la liste triée par éloignement croissant de toutes les cases au dessus  *)
(*   de la case (i, j), i.e. [(i, j-1); ...; (i, 0)]                         *)
val haut : int -> t -> t list;;

(* Fonction calculant la liste de toutes les cases sur la même colonne et    *)
(* au dessous d'une case donnée, dans une grille carrée.                     *)
(* Paramètres:                                                               *)
(* - la taille de la grille, entier positif.                                 *)
(* - la case (i, j) choisie.                                                 *)
(* Résultat:                                                                 *)
(* - la liste triée par éloignement croissant de toutes les cases au dessous *)
(*   de la case (i, j), i.e. [(i, j+1); ...; (i, t-1)]                       *)
val bas : int -> t -> t list;;
