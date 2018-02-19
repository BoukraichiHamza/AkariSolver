open Bdd_base;;



(* ************************************************************************* *)
(* FONCTIONS AVANCEES SUR LES BDD                                            *)
(* ************************************************************************* *)


(* La fonction qui teste si l'arbre passé en paramètre est bien un bdd, i.e. *)
(* respecte bien les invariants du type bdd (cf. bdd_base.node).             *)
(* Paramètres:                                                               *)
(* - un arbre de type bdd.                                                   *)
(* Résultat:                                                                 *)
(* - un booléen vrai si et seulement si l'arbre est bien un BDD.             *)
val est_bdd : bdd -> bool;;


(* La fonction qui calcule la conjonction de deux BDD.                       *)
(* Paramètres:                                                               *)
(* - deux BDD quelconques.                                                   *)
(* Résultat:                                                                 *)
(* - le bdd représentant la conjonction.                                     *)
val conjonction : bdd -> bdd -> bdd;;


(* La fonction qui calcule un bdd représentant les combinaisons de k cases   *)
(* contenant une lampe, tirées dans un ensemble.                             *)
(* Paramètres:                                                               *)
(* - un entier k>=0 représentant le nombre de cases avec une lampe à         *)
(*   choisir.                                                                *)
(* - une liste l dans laquelle choisir les cases.                            *)
(* Résultat:                                                                 *)
(* - le bdd représentant toutes les combinaisons de k cases avec une lampe   *)
(*   dans l, les autres cases ne possédant pas de lampe.                      *)
val combinaisons : int -> Case.t list -> bdd;;



(* ************************************************************************* *)
(* FONCTIONS PRINCIPALES SUR LES REGLES DE AKARI        *)
(* ************************************************************************* *)


(* Le type de l'état des cases dans la grille initiale. Cet état ne change   *)
(* pas, seul le contenu des cases change (voir type Case.contenu).           *)
(* Une case peut être vide, donc occupable par une lampe, ou bien noire avec *)
(* une indication optionnelle de voisinage, indiquant que n des 4 cases      *)
(* adjacentes doivent contenir une lampe.                                    *)
type statut =
  | Noir of int option
  | Vide;;


(* Le type des grilles du jeu akari, i.e. une fonction qui à chaque case     *)
(* renvoie son statut. Le comportement de cette fonction n'est pas spécifié  *)
(* lorsque la case passée en argument est en dehors de la grille de jeu.     *)
type grille = Case.t -> statut;;


(* La fonction qui calcule les cases adjacentes d'une case donnée dans une   *)
(* grille donnée.                                                            *)
(* Paramètres:                                                               *)
(* - la taille de la grille carrée.                                          *)
(* - la case dont on cherche les cases adjcentes.                            *)
(* Résultat:                                                                 *)
(* - une liste de toutes les cases adjacentes de la case donnée, dans les    *)
(*   limites de taille, incluant les cases noires.                           *)
val adjacentes : int -> Case.t -> Case.t list;;


(* La fonction qui calcule les voisines visibles d'une case donnée dans une  *)
(* grille donnée.                                                            *)
(* Paramètres:                                                               *)
(* - la taille de la grille carrée.                                          *)
(* - la grille initiale de jeu.                                              *)
(* - la case dont on cherche les voisines visibles.                          *)
(* Résultat:                                                                 *)
(* - une liste de toutes les cases visibles depuis la case donnée, i.e.      *)
(*   les cases accessibles sur la même ligne ou colonne sans rencontrer      *)
(*   de cases noires.                                                        *)
val voisines_visibles : int -> grille -> Case.t -> Case.t list;;



(* ************************************************************************* *)
(* FONCTIONS PRINCIPALES SUR LES BDD REPRESENTANT LES REGLES DE AKARI        *)
(* ************************************************************************* *)


(* La fonction qui calcule un bdd représentant les configurations correctes  *)
(* pour chaque case, i.e. selon les 4 règles suivantes:                      *)
(* - une case noire ne peut pas contenir de lampe.                           *)
(* - une case noire portant un numéro 'n' doit avoir exactement 'n' lampes   *)
(*   dans ses voisines adjacentes (0 <= n <= 4).                             *)
(* - toute case vide ne contenant pas de lampe doit être éclairée par une    *)
(*   lampe dans ses voisines visibles.                                       *)
(* - toute case contenant une lampe ne doit pas voir d'autres lampes         *)
(*   dans ses voisines visibles.                                             *)
(* Paramètres:                                                               *)
(* - la taille de la grille carrée.                                          *)
(* - la grille initiale de jeu.                                              *)
(* - la case à laquelle la propriété de correction est spécifiée.            *)
(* Résultat:                                                                 *)
(* - le bdd représentant toutes les combinaisons correctes relativement      *)
(*   à la case choisie dans la grille.                                       *)
val correction : int -> grille -> Case.t -> bdd;;



(* ************************************************************************* *)
(* TYPES + FONCTIONS GENERALES SUR LES CONFIGURATIONS                        *)
(* ************************************************************************* *)


(* Le type abstrait dont les valeurs représentent une état possible du jeu   *)
(* akari. Une configuration doit contenir assez d'information pour implanter *)
(* les fonctions demandées. Le type des configurations doit contenir:        *)
(* un bdd décrivant les positions possibles des lampes dans la grille        *)
(* + toute autre information jugée nécessaire...                             *)
type configuration;;


(* La fonction qui renvoie la configuration initiale, à partir de la grille  *)
(* fournie. Cette configuration contient notamment les positions possibles   *)
(* des lampes.                                                               *)
(* Paramètre:                                                                *)
(* - les paramètres de lancement de akari (taille et grille carrée)          *)
(* Résultat:                                                                 *)
(* - la configuration initiale.                                              *)
val initialisation : int -> grille -> configuration;;


(* La fonction qui teste si les positions des lampes dans une configuration  *)
(* donnée sont compatibles avec les indications fournies par la grille.      *)
(* Paramètre:                                                                *)
(* - la configuration courante.                                              *)
(* Résultat:                                                                 *)
(* - un booléen vrai si et seulement si la configuration courante            *)
(*   est impossible.                                                         *)
val impossible : configuration -> bool;;


(* La fonction qui renvoie l'information la plus sûre quant à la position    *)
(* d'une lampe, dans une configuration donnée.                               *)
(* Paramètre:                                                                *)
(* - la configuration courante.                                              *)
(* Précondition:                                                             *)
(* - la configuration n'est pas impossible (cf. fonction précédente).        *)
(* Résultat:                                                                 *)
(* - une case vide, i.e. non déjà marquée par le joueur comme contenant      *)
(*   une lampe, dont on est néanmoins sûr qu'elle en contient une;           *)
(*   ou bien aucune information (dans le cas None).                          *)
(* Postcondition:                                                            *)
(* - si au moins une case est sûre, cette fonction ne doit pas renvoyer None *)
val information : configuration -> Case.t option;;


(* La fonction qui met à jour la configurations maintenue par votre          *)
(* programme, dans le cas où le joueur a cliqué sur une case, qui a          *)
(* par conséquent changé de statut (passage de vide à lampe ou l'inverse).   *)
(* Cette information se répercute sur les configurations possibles.          *)
(* Paramètres:                                                               *)
(* - la case qui vient d'être cliquée par le joueur.                         *)
(* - la configuration avant le changement de la case.                        *)
(* Résultat:                                                                 *)
(* - la nouvelle configuration prenant en compte la case cliquée.            *)
val mise_a_jour : Case.t -> configuration -> configuration;;
