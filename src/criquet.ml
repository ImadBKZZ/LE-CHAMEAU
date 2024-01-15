open Tools
open Graph

type premierLeagueLeftGames = {
  mi: int;
  csk: int;
  kkr: int;
  dc: int;
}

type team = {
  name: int; 
  wins: int;
  losses: int;
  gameleft: int;
  championchip: premierLeagueLeftGames;
}

let mi = {
  name = 1;
  wins = 83;
  losses = 71;
  gameleft = 8;
  championchip = { mi = -1; csk = 1; kkr = 6; dc = 1 }
}
let csk = {
  name = 2;
  wins = 80;
  losses = 79;
  gameleft = 3;
  championchip = { mi = 1; csk = -1; kkr = 0; dc = 2 }
}

let kkr = {
  name = 3;
  wins = 78;
  losses = 78;
  gameleft = 6;
  championchip = { mi = 6; csk = 0; kkr = -1; dc = 0 }
}

let dc = {
  name = 4;
  wins = 77;
  losses = 82;
  gameleft = 3;
  championchip = { mi = 1; csk = 2; kkr = 0; dc = -1 }
}


(* Cette fonction permet qu'avec une liste contenant les equipes , on crée une liste de leurs numero d'equipe (Team.name)*)
let teamlistToIdlist teamlist = List.map(fun team -> team.name) teamlist



(*Cette fonction permet de choisir une equipe et de renvoyer une liste des autres equipes*)
let rec choixteam team = function
  | [] -> []
  | x :: rest when x = team -> rest
  | x :: rest -> x :: choixteam team rest


(*Cette fonction recoit comme argument la liste des equipes adverses et renvoie une liste des 
   combinaisons des confrontations entre ses equipes, un numero correspond à : (numero equipe 1 )x10 + (numero equipe 2)*)
let list_confontation lst =
    let rec combine acc x = function
      | [] -> List.rev acc
      | y :: rest -> combine ((x * 10 + y) :: acc) x rest
    in
    let rec process acc = function
      | [] -> List.rev acc
      | x :: rest -> process (combine acc x rest) rest
    in
    process [] lst ;;

    (*Cette fonction prend en argument la liste des equipes adverses et renvoit une liste de tout les noeuds de notre graphe*)
let createNodes teamliste =  0::teamliste@(list_confontation teamliste)@[5]

(*Cette fonction prend en argument un numero d'equipe(team.name) et renvoie la structure de l'equipe *)
let getteambyid id = match id with
  |1->mi
  |2->csk
  |3-> kkr
  |4->dc 
  |_-> failwith "inv indefini"

(*Cette fonction prend en argument une equipe et un id d'une autre equipe et renvoie le nombre de matches restants entre ces 2 equipes*)
let get_confront team i = match i with 
  |1-> team.championchip.mi
  |2->team.championchip.csk
  |3->team.championchip.kkr
  |4->team.championchip.dc
  |_->failwith"erreur"


  (*Fonction intermediaire *)
let gameleft id1 id2 = 
  let team1= getteambyid id1 in
  get_confront team1 id2


(*Cette fonction prend en argument l'equipe choisi , la liste de toutes les equipes et initialise tout les noeuds du graphe sans les arcs*)
let createGraph choosenteam liste= 
  let listeAdversaire = createNodes(teamlistToIdlist (choixteam  choosenteam liste)) in
  let rec loop acc = function 
  |[]-> acc
  |x::rest-> loop (new_node acc x) rest 
in loop empty_graph listeAdversaire

(*Cette fonction prend en argument l'equipe choisis et la liste de toutes les equipes  *)
let createGraphAndArcsAndMore choosenteam liste =
  let idlist = teamlistToIdlist (choixteam choosenteam liste) in 
  (*idlist contient le numero de toutes les equipes adverses*)
  let rencontre = list_confontation idlist in
  (*rencontre contient le numero de toutes les rencontres*)
  let rec createArcs gr = function
    | [] -> gr
    | x :: rest ->
      let arc_0 = add_arc gr 0 x {curr=0; capa=gameleft (x/10) (x mod 10)} in
      (*Arc_0 crée les arcs entre le noeud s et les noeuds confrontations*)
      let arc_1 = add_arc arc_0 x (x/10) {curr=0; capa= max_int} in
      (*Arc_1 crée les arcs entre les confrontations  et la 1ere equipe de la confrontation*)
      let arc_2 = add_arc arc_1 x (x mod 10) {curr=0; capa=max_int} in
      (*Arc_2 crée les arcs entre les confrontations  et la 2eme equipe de la confrontation*)
     
      Printf.printf "arcs team %d: vers noeud=%d, et noeud2=%d\n" x (x/10) (x mod 10);
      
      createArcs arc_2 rest
  in 
(*create_Arc4 crée les arcs entre les equipes vers le puit*)
  let rec createArc4 gr teamliste choosenteam = 
    match teamliste with
    | [] -> gr
    | x :: rest ->
      let team_x = getteambyid x in
      let new_capa = choosenteam.wins + choosenteam.gameleft - team_x.wins in
   
      Printf.printf "team %d: wins=%d, gameleft=%d, new_capa=%d\n" team_x.name team_x.wins team_x.gameleft new_capa;

      let gr_with_arc4 = add_arc gr x 5 {curr=0; capa=new_capa} in
      createArc4 gr_with_arc4 rest choosenteam 
  in

  let gr_with_arcs = createArcs (createGraph choosenteam liste) rencontre in
  createArc4 gr_with_arcs idlist choosenteam
