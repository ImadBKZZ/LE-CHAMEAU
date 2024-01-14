let read_mfile file_name =
  let channel = open_in file_name in
  let num_rows, num_columns =
    match input_line channel with
    | exception End_of_file -> close_in channel; failwith "Empty file"
    | line ->
      try
        let numbers = List.map int_of_string (String.split_on_char ' ' line) in
        match numbers with
        | [nr; nc] -> nr, nc
        | _ -> close_in channel; failwith "Incorrect format in the first line"
      with Failure _ -> close_in channel; failwith "Incorrect format in the first line"
  in
  let rec read_lines n acc =
    if n = 0 then List.rev acc
    else
      match input_line channel with
      | exception End_of_file -> close_in channel; failwith "Incomplete file"
      | line ->
        try
          let values = List.map int_of_string (String.split_on_char ' ' line) in
          if List.length values = num_columns then
            read_lines (n-1) (values :: acc)
          else (close_in channel; failwith "Incorrect number of columns")
        with Failure _ -> close_in channel; failwith "Incorrect line format"
  in
  let matrix = read_lines num_rows [] in
  close_in channel;
  (matrix, num_rows, num_columns);;

let display_matrix matrix =
  List.iter (fun row -> Printf.printf "[%s]\n" (String.concat "; " (List.map string_of_int row))) matrix;;
