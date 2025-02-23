open Graph
open Printf

type path = string

(* Format of text files:
   % This is a comment

   % A node with its coordinates (which are not used), and its id.
   n 88.8 209.7 0
   n 408.9 183.0 1

   % Edges: e source dest label id  (the edge id is not used).
   e 3 1 11 0 
   e 0 2 8 1

*)

(* Compute arbitrary position for a node. Center is 300,300 *)
let iof = int_of_float
let foi = float_of_int

let index_i id = iof (sqrt (foi id *. 1.1))

let compute_x id = 20 + 180 * index_i id

let compute_y id =
  let i0 = index_i id in
  let delta = id - (i0 * i0 * 10 / 11) in
  let sgn = if delta mod 2 = 0 then -1 else 1 in

  300 + sgn * (delta / 2) * 100


let convertTeamtoString team = match team with
  | 0 -> "s"
  | 1 -> "MI"
  | 2-> "CSK"
  | 3 -> "KKR"
  | 4 -> "DC"
  | 12 -> "MI-CSK"
  | 13 -> "MI-KKR"
  | 14 -> "MI-DC"
  | 23 -> "CSK-KKR"
  | 24 -> "CSK-DC"
  | 34 -> "KKR-DC"
  | 21 -> "MI-CSK"
  | 31 -> "MI-KKR"
  | 41 -> "MI-DC"
  | 32 -> "CSK-KKR"
  | 42 -> "CSK-DC"
  | 43 -> "KKR-CSK"
  | 5 -> "t"
  |_ -> failwith "WrongTeam"

let export path graph =

    (* Open a write-file. *)
    let ff = open_out path in
  
    fprintf ff "digraph finite_state_machine {\n";
    fprintf ff "  fontname=\"Helvetica,Arial,sans-serif\"\n";
    fprintf ff "  node [fontname=\"Helvetica,Arial,sans-serif\"]\n";
    fprintf ff "  edge [fontname=\"Helvetica,Arial,sans-serif\"]\n";
    fprintf ff "  rankdir=LR;\n";
    fprintf ff "  node [shape = circle];";
  
    (* Write all arcs *)
    let _ = e_fold graph (fun count arc -> fprintf ff "  %d -> %d [label = %s];\n" arc.src arc.tgt arc.lbl; count + 1) 0 in
  
    fprintf ff "}";
  
    close_out ff ;
    ()
let export2 path graph =

  (* Open a write-file. *)
  let ff = open_out path in

  fprintf ff "digraph finite_state_machine {\n";
  fprintf ff "  fontname=\"Helvetica,Arial,sans-serif\"\n";
  fprintf ff "  node [fontname=\"Helvetica,Arial,sans-serif\"]\n";
  fprintf ff "  edge [fontname=\"Helvetica,Arial,sans-serif\"]\n";
  fprintf ff "  rankdir=LR;\n";
  fprintf ff "  node [shape = circle];";
  fprintf ff "s [shape=doublecircle, style=filled, fillcolor=lightgray]\n";
  fprintf ff "t [shape=doublecircle, style=filled, fillcolor=lightgray]\n";

  (* Write all arcs *)
  let _ = e_fold graph (fun count arc -> fprintf ff "  %s -> %s [label = %s];\n" ("\"" ^(convertTeamtoString (arc.src))^"\"")  ("\"" ^(convertTeamtoString (arc.tgt))^"\"")  arc.lbl; count + 1) 0 in

  fprintf ff "}";

  close_out ff ;
  ()

let write_file path graph =

  (* Open a write-file. *)
  let ff = open_out path in

  (* Write in this file. *)
  fprintf ff "%% This is a graph.\n\n" ;

  (* Write all nodes (with fake coordinates) *)
  n_iter_sorted graph (fun id -> fprintf ff "n %d %d %d\n" (compute_x id) (compute_y id) id) ;
  fprintf ff "\n" ;

  (* Write all arcs *)
  let _ = e_fold graph (fun count arc -> fprintf ff "e %d %d %d %s\n" arc.src arc.tgt count arc.lbl ; count + 1) 0 in

  fprintf ff "\n%% End of graph\n" ;

  close_out ff ;
  ()

(* Reads a line with a node. *)
let read_node graph line =
  try Scanf.sscanf line "n %f %f %d" (fun _ _ id -> new_node graph id)
  with e ->
    Printf.printf "Cannot read node in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"

(* Ensure that the given node exists in the graph. If not, create it. 
 * (Necessary because the website we use to create online graphs does not generate correct files when some nodes have been deleted.) *)
let ensure graph id = if node_exists graph id then graph else new_node graph id

(* Reads a line with an arc. *)
let read_arc graph line =
  try Scanf.sscanf line "e %d %d %_d %s@%%"
        (fun src tgt lbl -> new_arc (ensure (ensure graph src) tgt) { src ; tgt ; lbl } )
  with e ->
    Printf.printf "Cannot read arc in line - %s:\n%s\n%!" (Printexc.to_string e) line ;
    failwith "from_file"

(* Reads a comment or fail. *)
let read_comment graph line =
  try Scanf.sscanf line " %%" graph
  with _ ->
    Printf.printf "Unknown line:\n%s\n%!" line ;
    failwith "from_file"

let from_file path =

  let infile = open_in path in

  (* Read all lines until end of file. *)
  let rec loop graph =
    try
      let line = input_line infile in

      (* Remove leading and trailing spaces. *)
      let line = String.trim line in

      let graph2 =
        (* Ignore empty lines *)
        if line = "" then graph

        (* The first character of a line determines its content : n or e. *)
        else match line.[0] with
          | 'n' -> read_node graph line
          | 'e' -> read_arc graph line

          (* It should be a comment, otherwise we complain. *)
          | _ -> read_comment graph line
      in      
      loop graph2

    with End_of_file -> graph (* Done *)
  in

  let final_graph = loop empty_graph in

  close_in infile ;
  final_graph

