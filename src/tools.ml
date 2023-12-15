open Graph

type flow =
  {
    curr: int;
    capa: int
  }

let clone_nodes gr = n_fold gr new_node empty_graph

let gmap gr f = e_fold gr (fun acc arc -> new_arc acc {arc with lbl = f arc.lbl}) (clone_nodes gr)

let add_arc gr id1 id2 flow =
  match find_arc gr id1 id2 with
  | None -> new_arc gr {src = id1; tgt = id2; lbl = flow}
  | Some arc -> new_arc gr {src = id1; tgt = id2; lbl = {curr = arc.lbl.curr + flow.curr; capa = arc.lbl.capa}}

let init gr = gmap gr (fun label -> {curr = 0; capa = label})

let string_of_flow flow = "\"" ^ string_of_int flow.curr ^ "/" ^ string_of_int flow.capa ^ "\""

(*
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
*)

let available_flow arc = arc.lbl.capa - arc.lbl.curr

let find_path gr s_id d_id =
  let rec loop path current_node =
    if current_node = d_id then Some path
    else find_available_flow_arc path (out_arcs gr current_node)
    
    and find_available_flow_arc path arcs =
      match arcs with
      | [] -> None
      | a::l -> if available_flow a > 0 then
        match loop (a::path) (a.tgt) with
        | None -> find_available_flow_arc path l
        | Some p -> Some p (*à revoir*)
      else find_available_flow_arc path l

  in loop [] s_id

let update_flow gr opt_path =
   let path =
    match opt_path with
    | None -> []
    | Some p -> p
   in
   let get_min_flow gr path =
    let rec loop minimum gr path = 
      match path with
      | [] -> minimum
      | arc::p -> loop (min minimum (available_flow arc)) gr p
      in loop (available_flow (List.hd path)) gr path
    in
    let min_flow = get_min_flow gr path in
    let rec add_flow gr path =
      match path with
      | [] -> gr
      | arc::p -> add_flow (add_arc gr arc.src arc.tgt {arc.lbl with curr = min_flow}) p
    in add_flow gr path
