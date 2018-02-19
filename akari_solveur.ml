open Bdd_base;;



(* ************************************************************************* *)
(* FONCTIONS AVANCEES SUR LES BDD                                            *)
(* ************************************************************************* *)



let rec est_bdd un_bdd = match un_bdd with
    |Top -> true
    |Bot -> true
    |Node(f0,caseF,f1) -> (match f0,f1 with
               |Bot,Bot -> false
               |Top,Top -> false
               |Bot,Top -> true
               |Top,Bot -> true
               |Top, Node(fdg,xd,fdd) -> (caseF <= xd) && (est_bdd fdd) && (est_bdd fdg)
               |Node(fgg,xg,fgd),Top ->(caseF <= xg) && (est_bdd fgg) && (est_bdd fgd)
               |Bot, Node(fdg,xd,fdd) -> (caseF <= xd) && (est_bdd fdg) && (est_bdd fdd)
               |Node(fgg,xg,fgd),Bot ->(caseF <= xg) && (est_bdd fgg) && (est_bdd fgd)
               |Node(fgg,xg,fgd),Node(fdg,xd,fdd) -> ((est_bdd fgg) && (est_bdd fgd)
                                           && (est_bdd fdg) && (est_bdd fdd) 
                                           && (caseF<=xg) && (caseF<=xd)));;    

    
let rec conjonction bdd1 bdd2 = match bdd1,bdd2 with
    |Top,_ -> bdd2
    |Bot,_ -> bot
    |_,Top -> bdd1
    |_,Bot -> bot
    |Node(f0,caseF,f1),Node(g0,caseG,g1) -> 
                        if caseF=caseG then
                            node(conjonction f0 g0,caseF, conjonction f1 g1)
                        else if caseF < caseG then
                            node(conjonction f0 bdd2,caseF,conjonction f1 bdd2)
                         else 
                           node(conjonction g0 bdd1,caseG,conjonction g1 bdd1);;
     
 (********************************************************************)
(*Tri fusion*)
let rec decompose = fun l ->
   match l with
   |[] -> ([],[])
   |[t] -> ([t],[])
   |t1::t2::q -> let (q1,q2)=decompose q in (t1::q1,t2::q2);;
   
let rec recompose = fun l1 l2 -> 
   match l1,l2 with
   |_,[] -> l1
   |[],_ -> l2
   |t1::q1,t2::q2 -> if t1<t2 then
                        t1::(recompose q1 l2)
                    else
                        t2::(recompose l1 q2);;
let rec tri_fusion = fun l ->
match l with 
|[] -> l
|[t] -> l
|_ -> let (l1,l2) = decompose l in
 recompose (tri_fusion l1) (tri_fusion l2);;
 (********************************************************************)

let rec combinaisons k l = 
    let lsort=tri_fusion l in
    match k,lsort with
    |0,[] -> top
    |_,[] -> bot
    |0,t::q -> node((combinaisons 0 q), t, bot) 
    |k,t::q -> node((combinaisons k q),t,(combinaisons (k-1) q)) ;;



(* ************************************************************************* *)
(* FONCTIONS PRINCIPALES SUR LES REGLES DE AKARI        *)
(* ************************************************************************* *)

type statut =
  | Noir of int option
  | Vide;;

type grille = Case.t -> statut;;


let adjacentes taille case = 
	let rec adj_acc liste acc = match liste with
	|[] -> acc
	|t::_ -> t::acc
	in adj_acc (Case.gauche taille case) 
	(adj_acc (Case.droite taille case) 
	(adj_acc (Case.haut taille case) 
	(adj_acc (Case.bas taille case) [])));;



 let voisines_visibles taille une_grille case = 
     let rec voivi_acc la_grille adj_case acc =
     match adj_case with
     |[] -> acc
     |t::q -> match (la_grille t) with
              |Vide ->   voivi_acc la_grille q (t::acc)
              | _ -> voivi_acc la_grille q acc
    in voivi_acc une_grille (Case.gauche taille case)
(voivi_acc une_grille (Case.droite taille case)
(voivi_acc une_grille (Case.haut taille case)
(voivi_acc une_grille (Case.bas taille case) [])));;
           
(*************************************************************************** *)
(* FONCTIONS PRINCIPALES SUR LES BDD REPRESENTANT LES REGLES DE AKARI        *)



(*Fonction disjonction*)
(*Fonction qui calcule la disjonction de 2 bdd*)

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

(*Fonctions qui retourne la liste des cases visibles d'une case sur sa colonne ou ligne*)
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
                     
                           
let correction taille une_grille case = 
            match (une_grille case) with
            |Noir None -> negvariable case
            |Noir Some(a) -> conjonction (negvariable case) (combinaisons a (adjacentes taille case))
            |Vide ->(disjonction
			(conjonction (posvariable case) (combinaisons 0 (voisines_visibles taille une_grille case)))
			(disjonction
			(conjonction 
			(negvariable case) (conjonction (combinaisons 1 (colonnes_visible taille une_grille case)) (combinaisons 1 (lignes_visible taille une_grille case))))
			(conjonction (negvariable case) (combinaisons 1 (voisines_visibles taille une_grille case)))));;
			
							



(* ************************************************************************* *)
(* TYPES + FONCTIONS GENERALES SUR LES CONFIGURATIONS                        *)
(* ************************************************************************* *)


type configuration = bdd*bdd*int*grille*Case.t list ;;



let initialisation taille une_grille = 
        let l = List.flatten(Case.lignes taille) in
            let bddinit=
	    	    let rec init_bdd liste =
		    match liste with
			|[] -> top
			|t::q -> conjonction (correction taille une_grille t) (init_bdd  q)
				    in  init_bdd l
					in					
					    (bddinit,bddinit,taille,une_grille,[]);;



let impossible conf = let (bdd_courant,bdd_in,taille,une_grille,_)=conf in
       (conjonction bdd_in bdd_courant)=bot ;;


let information conf = 
	let (bbd_courant,bdd_in,taille,une_grille,l) = conf in
		let  rec inform (bdd,bddin,taille,grille,liste) liste_case =
			match liste_case with
				|[]->None
				|t::q -> if (conjonction bdd (posvariable t))=bdd then
							Some t
						else
							inform (bdd,bddin,taille,grille,liste) q
		    in
				inform (bbd_courant,bdd_in,taille,une_grille,l) (List.flatten (Case.lignes taille));;


(*Fonction qui teste si une case appartient à une liste*)

let rec appartient case liste = 
	match liste with
		|[] -> false
		|t::q -> case=t || appartient case q;;
		
(*Fonction qui retire une case d'une liste*)

let rec remove case liste =
	match liste with
	|[] -> []
	|t::q -> if t=case then
				q
			else
				t::(remove case q);;
				
(*Fonction qui retourne le bdd équivalent à allumer toute les cases d'une liste*)

let rec allume liste = 
	match liste with
		|[] -> top
		|t::q -> conjonction (posvariable t) (allume q);;



let mise_a_jour case conf = 
	let (bdd_courant,bdd_in,taille,une_grille,l) = conf in
		match l with
			|[] -> (conjonction bdd_courant (posvariable case),bdd_in,taille,une_grille,[case])
			|_ ->if not (appartient case l) then
					((conjonction bdd_courant (posvariable case)),bdd_in,taille,une_grille,(case::l))
				else
						let new_l = remove case l in
							((conjonction bdd_in (allume new_l)),bdd_in,taille,une_grille,new_l);;

