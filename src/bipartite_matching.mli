open Graph

val create_rows_nodes: int graph -> int -> int graph
val create_cols_nodes: int graph -> int -> int -> int graph
val arcs_from_source_to_rows: int graph -> int -> int -> int graph
val arcs_from_rows_to_cols: int graph -> int list list -> int -> int -> int graph
val arcs_from_cols_to_sink: int graph -> int -> int -> int -> int graph
val graph_from_matrix: int list list -> int graph