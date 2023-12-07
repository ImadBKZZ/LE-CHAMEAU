open Graph

type flow =
  {
    curr: int;
    capa: int
  }

let clone_nodes gr = n_fold gr new_node empty_graph

let gmap gr f = e_fold gr (fun acc arc -> new_arc acc {arc with lbl = f arc.lbl}) (clone_nodes gr)

let add_arc gr id1 id2 n =
  match find_arc gr id1 id2 with
  | None -> new_arc gr {src = id1; tgt = id2; lbl = n}
  | Some arc -> new_arc gr {src = id1; tgt = id2; lbl = arc.lbl + n}

let init gr = gmap gr (fun label -> {capa = label; curr = 0})

let string_of_flow flow = "\"" ^ string_of_int flow.curr ^ "/" ^ string_of_int flow.capa ^ "\""

let voisins_non_visites voisins visited =
  let rec loop acc = function
    | [] -> acc
    | arc::rest -> if List.mem arc.tgt visited then loop (arc::acc) rest else loop acc rest
  in
  loop [] voisins

let find_path gr s_id d_id =
  let rec find_path_helper visited_path current_node =
    if current_node = d_id
      then Some visited_path
    else
      let voisins = out_arcs gr current_node in
      let check_not_visited = voisins_non_visites voisins visited_path in
      match check_not_visited with
      | [] -> None
      | arc::_ -> find_path_helper (arc.tgt::visited_path) arc.tgt
  in find_path_helper [] s_id
