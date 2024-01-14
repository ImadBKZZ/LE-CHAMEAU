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

val teamlistToIdlist : team list ->id list
val choixteam : 'a -> 'a list ->'a list
val transform_list : id list -> id list 
val createNodes : id list -> id list
val getteambyid : id -> team 
val get_confront : team -> id -> id
val gameleft : id -> id -> id 
val createGraph : team -> team list -> 'a graph
val createGraphAndArcsAndMore : team -> team list -> flow graph
val mi : team
val csk : team
val kkr : team
val dc : team

