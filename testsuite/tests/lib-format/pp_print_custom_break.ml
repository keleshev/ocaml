(* TEST *)

(*

A test file for Format.pp_print_custom_break.

*)
let fprintf, printf, list = Format.(fprintf, printf, pp_print_list)
let string, custom_break = Format.(pp_print_string, pp_print_custom_break)

let () = Format.set_margin 30

let example = [
  "Foo"; "Baz"; "Bar"; "Qux"; "Quux"; "Quuz"; "Corge"; "Grault"; "Garply";
]

module Format_array = struct
  let pp_sep ppf () = fprintf ppf ";@ "

  let format box_type ppf array =
    fprintf ppf "[@;<0 2>@[<%s>%a@]%t]" box_type
      (list ~pp_sep string) array
      (custom_break ~no_break:("", 0, "") ~yes_break:(";", 0, ""))

  let () =
    printf "@[<v 0>%a@]@\n" (format "v") example;
    printf "@[<b 0>%a@]@\n" (format "b") example;
    printf "@[<h 0>%a@]@\n@\n" (format "h") example
end


module Format_statements = struct
  let pp_sep ppf () =
    custom_break ppf ~no_break:(";", 1, "") ~yes_break:("", 0, "")

  let rec format box_type ppf items =
    fprintf ppf "{@;<0 2>@[<%s>%a@]@,}" box_type
      (list ~pp_sep string) items

  let () =
    printf "@[<v 0>%a@]@\n" (format "v") example;
    printf "@[<b 0>%a@]@\n" (format "b") example;
    printf "@[<h 0>%a@]@\n@\n" (format "h") example
end


module Format_function = struct
  let pp_sep ppf () = fprintf ppf "@ | "
  let format_case ppf = fprintf ppf "%s -> ()"

  let rec format box_type ppf items =
    fprintf ppf "@[<%s>function%t%a@]" box_type
      (custom_break ~no_break:("", 1, "") ~yes_break:("", 0, "| "))
      (list ~pp_sep format_case) items

  let () =
    printf "@[<v 0>%a@]@\n" (format "v") example;
    printf "@[<b 0>%a@]@\n" (format "b") example;
    printf "@[<h 0>%a@]@\n" (format "h") example
end
