open Graph

let clone_nodes gr = n_fold gr new_node empty_graph

let gmap gr f = e_fold gr (fun acc arc -> new_arc acc {arc with lbl = f arc.lbl}) (clone_nodes gr)

let add_arc gr id1 id2 n =
  match find_arc gr id1 id2 with
  | None -> new_arc gr {src = id1; tgt = id2; lbl = n}
  | Some arc -> new_arc gr {src = id1; tgt = id2; lbl = arc.lbl + n}