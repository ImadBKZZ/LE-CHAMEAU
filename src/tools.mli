open Graph

type flow =
  {
    curr: int;
    capa: int
  }

val clone_nodes: 'a graph -> 'b graph
val gmap: 'a graph -> ('a -> 'b) -> 'b graph
val add_arc: flow graph -> id -> id -> flow -> flow graph
val init: int graph -> flow graph
val string_of_flow: flow -> string
val find_path: flow graph -> id -> id -> flow arc list option
val update_flow: flow graph -> flow arc list option -> flow graph
val print_path: flow arc list option -> unit