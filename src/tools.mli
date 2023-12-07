open Graph

type flow =
  {
    curr: int;
    capa: int
  }

val clone_nodes: 'a graph -> 'b graph
val gmap: 'a graph -> ('a -> 'b) -> 'b graph
val add_arc: int graph -> id -> id -> int -> int graph
val init: int graph -> flow graph
val string_of_flow: flow -> string
val find_path: 'a graph -> id -> id -> id list option