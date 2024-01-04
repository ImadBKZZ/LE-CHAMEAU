open Graph

type flow =
  {
    curr: int;
    capa: int
  }

let clone_nodes gr = n_fold gr new_node empty_graph

let gmap gr f = e_fold gr (fun acc arc -> new_arc acc {arc with lbl = f arc.lbl}) (clone_nodes gr)
let back_arcs gr = e_fold gr (fun acc arc -> new_arc acc {src = arc.tgt; tgt = arc.src; lbl = {curr = arc.lbl.capa; capa = arc.lbl.capa}}) gr

let add_arc gr id1 id2 flow =
  match find_arc gr id1 id2 with
  | None -> new_arc gr {src = id1; tgt = id2; lbl = flow}
  | Some arc -> new_arc gr {src = id1; tgt = id2; lbl = {curr = arc.lbl.curr + flow.curr; capa = arc.lbl.capa}}

let sub_arc gr id1 id2 flow =
  match find_arc gr id1 id2 with
  | None -> new_arc gr {src = id1; tgt = id2; lbl = flow}
  | Some arc -> new_arc gr {src = id1; tgt = id2; lbl = {curr = arc.lbl.curr - flow.curr; capa = arc.lbl.capa}}

let init gr = back_arcs (gmap gr (fun label -> {curr = 0; capa = label}))

let string_of_flow flow = "\"" ^ string_of_int flow.curr ^ "/" ^ string_of_int flow.capa ^ "\""

let print_path opt_path = 
  let path_from_opt_path opt_path =
    match opt_path with
    | None -> []
    | Some path -> path
  in
  let print_arc arc = Printf.printf "(%d -> %d){%d/%d} " arc.src arc.tgt arc.lbl.curr arc.lbl.capa
  in
  let () = List.iter print_arc (path_from_opt_path opt_path) in 
  Printf.printf "\n"


let available_flow arc = arc.lbl.capa - arc.lbl.curr

let get_path gr s_id d_id =
  let rec check_path_found path current_node =
    if current_node = d_id then Some (List.rev path)
    else find_path path (out_arcs gr current_node)

  and find_path path arcs =
    match arcs with
    | [] -> None
    | a::l -> if List.mem a path then find_path path l else
      if available_flow a > 0 then 
        match check_path_found (a::path) (a.tgt) with
        | None -> find_path path l
        | Some p -> Some p
      else find_path path l

  in check_path_found [] s_id

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
    | arc::p -> 
      let new_graph = add_arc gr arc.src arc.tgt {arc.lbl with curr = min_flow}
    in add_flow (sub_arc new_graph arc.tgt arc.src {arc.lbl with curr = min_flow}) p
  in add_flow gr path

let rec ford_fulkerson gr s_id d_id = 
  match get_path gr s_id d_id with
  | None -> gr
  | Some path -> ford_fulkerson (update_flow gr (Some path)) s_id d_id
