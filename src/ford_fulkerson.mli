open Graph
open Tools

val set_flow: flow graph -> flow arc -> flow -> flow graph
val arc_exists: 'a graph -> id -> id -> bool
val init: int graph -> flow graph
val back_arcs: flow graph -> flow graph
val string_of_flow: flow -> string
val print_path: flow arc list option -> unit
val available_flow: flow arc -> int
val get_path: flow graph -> id -> id -> flow arc list option
val update_flow: flow graph -> flow arc list option -> flow graph
val optimal_flow: flow graph -> id -> id -> flow graph
val ford_fulkerson: flow graph -> id -> id -> flow graph