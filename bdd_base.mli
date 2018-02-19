
(* ************************************************************************* *)
(* TYPES + FONCTIONS DE BASE SUR LES BDD                                     *)
(* ************************************************************************* *)

(* Le type des BDD où les variables sont des cases de la grille.             *)
(* L'ordre entre les cases est l'ordre générique croissant prédéfini.        *)
(* Les constructeurs sont "privés", i.e. on peut les utiliser uniquement     *)
(* dans un cas de filtrage, pas dans une expression.                         *)
(* Pour construire un noeud, il faut utiliser la fonction node fournie       *)
(* qui garantit les bonnes propriétés d'efficacité des bdd.                  *)
(* Pour les constantes Top et Bot, utiliser les fonctions top et bot.        *) 
type bdd = private
| Top                              (* True                                   *)
| Bot                              (* False                                  *)
| Node of bdd * Case.t * bdd;;     (* Décomposition de Shannon (f0, v, f1)   *)


(* Les deux constantes booléennes Bot et Top, définies respectivement        *)
(* par les variables bot et top.                                             *)
val bot : bdd;;
val top : bdd;;


(* La fonction qui permet de construire les noeuds des arbres binaires       *)
(* que sont les BDD. Elle permet également de garantir la canonicité         *)
(* de la représentation des formules logiques, ainsi que de diminuer         *)
(* l'occupation mémoire de ces structures, par rapport à l'usage naïf        *)
(* du constructeur Node.                                                     *)
(* Paramètre:                                                                *)
(* - un triplet (f0, v, f1) représentant une décomposition de Shannon        *)
(*   (cf. Node), tel que la variable racine v est strictement inférieure     *)
(*   aux variables apparaissant dans f0 et dans f1.                          *)
(* Résultat:                                                                 *)
(* - le bdd représentant la même formule que celle obtenue avec Node,        *)
(*   mais garantissant de bonnes propriétés.                                 *)
val node : bdd * Case.t * bdd -> bdd;;


(* La fonction qui, à partir d'une case C, considéree comme une variable     *)
(* propositionnelle, construit le BDD représentant la proposition C.         *)
(* Paramètre:                                                                *)
(* - une case C quelconque.                                                  *)
(* Résultat:                                                                 *)
(* - le bdd 'node (bot, C, top)' représentant la proposition: 'C',           *)
(*   indiquant que C contient une lampe.                                     *)
val posvariable : Case.t -> bdd;;


(* La fonction qui construit la proposition not C, à partir d'une case C.    *)
(* Paramètre:                                                                *)
(* - une case C quelconque.                                                  *)
(* Résultat:                                                                 *)
(* - le bdd 'node (top, C, bot)' représentant la proposition: 'not C',       *)
(*   indiquant que C ne contient pas de lampe.                               *)
val negvariable : Case.t -> bdd;;
