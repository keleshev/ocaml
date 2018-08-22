(* TEST *)

(*

A test file for Format.pp_print_custom_break.

*)
let fprintf, printf, list = Format.(fprintf, printf, pp_print_list)
let custom_break = Format.pp_print_custom_break


module Format_array = struct
  let rec format_array box_type ppf = function
    | `Number n ->
        fprintf ppf "%d" n
    | `Array items ->
        let pp_sep ppf () = fprintf ppf ";@ " in
        fprintf ppf "[@;<0 2>@[<%s>%a@]%t]" box_type
          (list ~pp_sep (format_array box_type)) items
          (custom_break ~no_break:"" ~yes_break:(";", ""))

  let example = `Array [`Array [`Number 123; `Number 234]; `Number 345]

  let () =
    printf "@[<v 0>%a@]@\n" (format_array "v") example;
    printf "@[<h 0>%a@]@\n" (format_array "h") example
end


module Format_statements = struct
  let rec format_statements box_type ppf = function
    | `Statement s ->
        fprintf ppf "%s" s
    | `Braces statements ->
        let pp_sep ppf () =
          custom_break ppf ~no_break:"; " ~yes_break:("", "") in
        fprintf ppf "{@;<0 2>@[<%s>%a@]@,}" box_type
          (list ~pp_sep (format_statements box_type)) statements

  let example = `Braces [`Statement "foo"; `Statement "bar"; `Statement "baz"]

  let () =
    printf "@[<v 0>%a@]@\n" (format_statements "v") example;
    printf "@[<h 0>%a@]@\n" (format_statements "h") example
end
