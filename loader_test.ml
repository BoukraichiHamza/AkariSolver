#load "case.cmo";;
#load "memo.cmo";;
#load "bdd_base.cmo";;
#load "akari_solveur.cmo";;
#use "script_affichage.ml";;
#use "test.ml";;



ocamlc case.mli case.cmo memo.mli memo.cmo bdd_base.mli bdd_base.cmo akari_solveur.mli akari_solveur.ml




	(disjonction
					(conjonction (posvariable case) (combinaisons 0 (voisines_visibles taille une_grille case)))
					(disjonction
					(conjonction 
					(negvariable case) (conjonction (combinaisons 1 (colonnes_visible taille une_grille case)) (combinaisons 1 (lignes_visible taille une_grille case))))
					(conjonction (negvariable case) (combinaisons 1 (voisines_visibles taille une_grille case)))));;



pos1=conjonction (posvariable case) (combinaisons 0 (voisines_visibles taille une_grille case))
pos2=conjonction (combinaisons 1 (colonnes_visible taille une_grille case)) (combinaisons 1 (lignes_visible taille une_grille case))
pos3=combinaisons 1 (voisines_visibles taille une_grille case)

disjonction pos1 (disjonction (conjonction (negvariable case) pos2) (conjonction (negvariable case) pos3))



 let pos1 = (conjonction (combinaisons 0 (voisines_visibles_ligne taille une_grille case ))  (combinaisons 1 (voisines_visibles_colonne taille une_grille case ))) in
  let pos2 = (conjonction (combinaisons 1 (voisines_visibles_ligne taille une_grille case ))  (combinaisons 0 (voisines_visibles_colonne taille une_grille case ))) in
  let pos3 = (conjonction (combinaisons 1 (voisines_visibles_ligne taille une_grille case ))  (combinaisons 1 (voisines_visibles_colonne taille une_grille case ))) in
let pos4 =conjonction (posvariable case) (combinaisons 0 (voisines_visibles taille une_grille case))
 in
 disjonction pos4 (disjonction (conjonction (negvariable case) pos3) (disjonction (conjonction (negvariable case) pos2) (conjonction (negvariable case) pos1));;







(*a copier dans le terminal*)


let rec disjonction bdd1 bdd2 = match bdd1,bdd2 with
    |Top,_ -> top
    |Bot,_ -> bdd2
    |_,Top -> top
    |_,Bot -> bdd1
    |Node(f0,caseF,f1),Node(g0,caseG,g1) -> 
                        if caseF=caseG then
                            node(disjonction f0 g0,caseF, disjonction f1 g1)
                        else if caseF < caseG then
                            node(disjonction f0 bdd2,caseF,disjonction f1 bdd2)
                         else 
                           node(disjonction g0 bdd1,caseG,disjonction g1 bdd1);;
                           

let colonnes_visible   taille une_grille case = 
     let rec voivi_acc la_grille adj_case acc =
     match adj_case with
     |[] -> acc
     |t::q -> match (la_grille t) with
              |Vide ->   voivi_acc la_grille q (t::acc)
              | _ -> voivi_acc la_grille q acc
    in voivi_acc une_grille (Case.haut taille case)
(voivi_acc une_grille (Case.bas taille case) []);;   

let lignes_visible   taille une_grille case = 
     let rec voivi_acc la_grille adj_case acc =
     match adj_case with
     |[] -> acc
     |t::q -> match (la_grille t) with
              |Vide ->   voivi_acc la_grille q (t::acc)
              | _ -> voivi_acc la_grille q acc
in voivi_acc une_grille (Case.gauche taille case)
(voivi_acc une_grille (Case.droite taille case) []);;  

let rec appartient case liste = 
	match liste with
		|[] -> false
		|t::q -> case=t || appartient case q;;
		


let rec remove case liste =
	match liste with
	|[] -> []
	|t::q -> if t=case then
				q
			else
				t::(remove case q);;
				


let rec allume liste = 
	match liste with
		|[] -> top
		|t::q -> conjonction (posvariable t) (allume q);;



