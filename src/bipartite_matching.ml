open Graph
open Tools

let rec create_rows_nodes gr rows =
  match rows with
  | -1 -> gr
  | r -> create_rows_nodes (new_node gr r) (rows-1)

let rec create_cols_nodes gr rows cols =
  match cols with
  | -1 -> gr
  | c -> create_cols_nodes (new_node gr (rows + c)) rows (cols-1)

let rec arcs_from_source_to_rows gr source rows =
  match rows with
  | -1 -> gr
  | r -> arcs_from_source_to_rows (new_arc gr {src = source; tgt = r; lbl = 1}) source (rows-1)

let rec arcs_from_rows_to_cols_aux gr matrix rows cols curr_row curr_col =
  match curr_row with
  | -1 -> gr
  | r ->
    match curr_col with
    | -1 -> arcs_from_rows_to_cols_aux gr matrix rows cols (curr_row-1) cols
    | c -> arcs_from_rows_to_cols_aux
      (if List.nth (List.nth matrix r) c == 1
      then new_arc gr {src = r; tgt = rows + c+1; lbl = 1}
      else gr) matrix rows cols curr_row (curr_col-1)

let arcs_from_rows_to_cols gr matrix rows cols =
  arcs_from_rows_to_cols_aux gr matrix rows cols rows cols

let rec arcs_from_cols_to_sink gr sink rows cols =
  match cols with
  | -1 -> gr
  | c -> arcs_from_cols_to_sink (new_arc gr {src = rows + c; tgt = sink; lbl = 1}) sink rows (cols-1)

let graph_from_matrix matrix =

  let rows = List.length matrix in
  let cols = List.length (List.hd matrix) in

  let source_id = rows + cols in
  let sink_id = source_id + 1 in

  let graph = empty_graph in
  let graph_rows_nodes = create_rows_nodes graph (rows-1) in
  let graph_cols_nodes = create_cols_nodes graph_rows_nodes rows (cols-1) in
  let graph_with_source = new_node graph_cols_nodes source_id in
  let graph_with_sink = new_node graph_with_source sink_id in
  let graph_source_arcs = arcs_from_source_to_rows graph_with_sink source_id (rows-1) in
  let graph_sink_arcs = arcs_from_cols_to_sink graph_source_arcs sink_id rows (cols-1) in
  let complete_graph = arcs_from_rows_to_cols graph_sink_arcs matrix (rows-1) (cols-1) in
  complete_graph

let printf_nb_applicants_jobs gr source_id sink_id =
  let nb_aplicants = List.length (out_arcs gr source_id) in
  let (nb_jobs_got, nb_jobs) = e_fold gr
  (fun acc arc ->
    match find_arc gr arc.src arc.tgt with
    | Some a ->
      if a.tgt == sink_id then
        if a.lbl.curr == 1
        then ((fst acc)+1, (snd acc)+1)
        else (fst acc, (snd acc)+1)
      else acc
    | None -> acc
  ) (0, 0) in
  Printf.printf "\n%d/%d applicants got %d/%d jobs.\n\n" nb_jobs_got nb_aplicants nb_jobs_got nb_jobs