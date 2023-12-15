open Gfile
open Graph
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

  (*Valid paths in graph1.txt*)
  (*
  let path1 = Some [{src = 0; tgt = 2; lbl = {curr = 0; capa = 8}}; {src = 2; tgt = 4; lbl = {curr = 0; capa = 12}}; {src = 4; tgt = 5; lbl = {curr = 0; capa = 14}}] in
  let path2 = Some [{src = 0; tgt = 1; lbl = {curr = 0; capa = 7}}; {src = 1; tgt = 5; lbl = {curr = 0; capa = 21}}] in
  *)
  let path3 = Some [{src = 0; tgt = 3; lbl = {curr = 0; capa = 10}}; {src = 3; tgt = 4; lbl = {curr = 0; capa = 5}}; {src = 4; tgt = 5; lbl = {curr = 0; capa = 14}}] in

  let graph = from_file infile in
  let graph1 = gmap graph int_of_string in
  let graph2 = init graph1 in
  let () = Printf.printf "Path: " in
  let () = print_path path3 in
  let graph3 = update_flow graph2 path3 in

  (* Rewrite the graph that has been read. *)
  let () = export outfile (gmap graph3 string_of_flow) in
  ()
