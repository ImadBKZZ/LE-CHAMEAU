open Gfile
open Tools
open Ford_fulkerson
open Mfile
open Bipartite_matching

let () =

let dmo = int_of_string Sys.argv.(1) in

if dmo == 1 then

(
(* Check the number of command-line arguments *)
if Array.length Sys.argv <> 6 then
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

let infile = Sys.argv.(2)
and outfile = Sys.argv.(5)

(* These command-line arguments are not used for the moment. *)
and _source = int_of_string Sys.argv.(3)
and _sink = int_of_string Sys.argv.(4)
in

(* Open file *)

let graph = from_file infile in
let graph1 = gmap graph int_of_string in
let graph2 = ford_fulkerson graph1 _source _sink in

(* Rewrite the graph that has been read. *)
let () = export outfile (gmap graph2 string_of_flow) in
()
)
else
(
let infile = Sys.argv.(2)
and outfile1 = Sys.argv.(3) in

let (matrix, rows, cols) = read_mfile infile in
let source = rows + cols in
let sink = source + 1 in
let m_graph = graph_from_matrix matrix in
let ff_m_graph = ford_fulkerson m_graph source sink in

let () = display_matrix matrix; export outfile1 (gmap ff_m_graph string_of_flow) in
()
)