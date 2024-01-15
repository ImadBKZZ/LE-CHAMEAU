# Projet Ocaml: Problème élimination du Criquet

Base project for Ocaml project on Ford-Fulkerson. This project contains some simple configuration files to facilitate editing Ocaml in VSCode.

To use, you should install the *OCaml* extension in VSCode. Other extensions might work as well but make sure there is only one installed.
Then open VSCode in the root directory of this repository (command line: `code path/to/ocaml-maxflow-project`).

Features :
 - full compilation as VSCode build task (Ctrl+Shift+b)
 - highlights of compilation errors as you type
 - code completion
 - automatic indentation on file save


A makefile provides some useful commands:
 - `make build` to compile. This creates an ftest.native executable
 - `make demo` to run the `ftest` program with some arguments
 - `make format` to indent the entire project
 - `make edit` to open the project in VSCode
 - `make clean` to remove build artifacts

In case of trouble with the VSCode extension (e.g. the project does not build, there are strange mistakes), a common workaround is to (1) close vscode, (2) `make clean`, (3) `make build` and (4) reopen vscode (`make edit`).

## Explication ## 
Probleme du Criquet : 
On a 4 équipes qui jouent un tournoi , les équipes jouent 162 matches. Pour chaque equipe , on enregistre le nombre de matches gagnés, le nombre de matches perdus, les macthes restants totals et le nombre de matches restants contre chaque équipe.
Avec un point de depart, on veut savoir quelle(s) equipe(s) sera eliminee(s) de la premiere place.
Le but de l'algorithme est de choisir une equipe parmi les 4 équipes,  et traiter le nombre de rencontre restant pour savoir si elle sera éliminee de la premiere place. 
On utilise l'algorithme Ford_Fulkerson afin de determiner si dans le meilleur cas possible une équipe peut gagner le championnat en arrivant en premiere place.


D'abord on a crée les types:

"premierLeagueLeftGames" pour stocker le nombre de matches restants contre chaque equipes

"Team" pour avoir la structure de chaque equipe (matches joue, matche perdu , matches restants et "premierLeagueLeftGames)"

Tous les matchs restants entre les équipes x et y (autres que l'équipe z choisie) sont ajoutés au nombre de gains pour x AND y (capacités d'arête infinie).

La capacité sur les bords (x, t) garantit qu'aucune équipe ne gagne trop de matchs, empêchant l'équipe z de gagner.

L'equipe z est éliminée si le flux max sature tous les arcs sortant du noeud s 
