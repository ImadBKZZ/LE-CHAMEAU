open Gfile
open Tools
    
let () =

  (* Check the number of command-line arguments *)
  if Array.length Sys.argv <> 5 then
    begin
      Printf.printf
        "\n ✻  Usage: %s infile source sink outfile\n\n%s%!" Sys.argv.(0)
        ("    🟄  infile  : input file containing a graph\n" ^
         "    🟄  source  : identifier of the source vertex (used by the ford-fulkerson algorithm)\n" ^
         "    🟄  sink    : identifier of the sink vertex (ditto)\n" ^
         "    🟄  outfile : output file in which the result should be written.\n\n") ;
      exit 0
    end ;


  (* Arguments are : infile(1) source-id(2) sink-id(3) outfile(4) *)
  
  let infile = Sys.argv.(1)
  and outfile = Sys.argv.(4)
  
  (* These command-line arguments are not used for the moment. *)
  and _source = int_of_string Sys.argv.(2)
  and _sink = int_of_string Sys.argv.(3)
  in

  (* Open file *)
  let graph = from_file infile in
  let graph1 = gmap graph (fun label -> {capa = int_of_string label; curr = 0}) in

  (*let graph2 = clone_nodes graph in*)
  (*let graph3 = gmap graph (fun _ -> "Chameau") in*)

  (* Rewrite the graph that has been read. *)
  let () = export outfile (gmap graph1 string_of_flow) in
    match find_path graph1 0 5 with
    | None -> Printf.printf "None\n"
    | Some l -> (List.iter (Printf.printf "%d ") l)
