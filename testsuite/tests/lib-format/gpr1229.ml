(* TEST *)

(*
A test file for Format.print_string_if_newline,
print_break_or_string_if_newline and print_fits_or_breaks.
*)

let set_margin n =
  Format.set_margin n;
  Format.set_max_indent (n - 1)

open Format;;

let print_pre_break = pp_print_pre_break std_formatter
let print_string_if_newline = pp_print_string_if_newline std_formatter
let print_or_newline = pp_print_or_newline std_formatter
let print_fits_or_breaks = pp_print_fits_or_breaks std_formatter

let test_print_string_if_newline m b =
  set_margin m;
  open_hovbox 2;
  print_string "before";
  print_space ();
  if b then (
    print_if_newline ();
    print_string "if newline"
  ) else (
    print_string_if_newline "if newline"
  );
  print_space ();
  print_string "after";
  open_hvbox 2;
  print_space ();
  print_string "later";
  close_box ();
  close_box ();
  print_newline ()
;;

let print_if_newline_vs_print_string_if_newline m =
  print_string "margin = ";
  print_int m;
  print_newline ();
  print_endline "using print_if_newline:";
  test_print_string_if_newline m true;
  print_endline "using print_string_if_newline:";
  test_print_string_if_newline m false;
  print_newline ()
;;

print_if_newline_vs_print_string_if_newline 17;;
print_if_newline_vs_print_string_if_newline 18;;
print_if_newline_vs_print_string_if_newline 20;;
print_if_newline_vs_print_string_if_newline 30;;

let test_print_or_newline m =
  print_string "margin = ";
  print_int m;
  print_newline ();
  set_margin m;
  open_hvbox 2;
  print_string "before";
  print_space ();
  print_or_newline 4 0 "fits" "broke";
  print_space ();
  print_string "after";
  print_space ();
  print_string "final";
  close_box ();
  print_newline ()
;;

test_print_or_newline 20;;
test_print_or_newline 35;;

print_newline ();;

let test_print_fits_or_breaks m =
  print_string "margin = ";
  print_int m;
  print_newline ();
  set_margin m;
  open_hvbox 2;
  print_string "before";
  print_space ();
  print_string "after";
  print_space ();
  print_fits_or_breaks "fit" 1 0 "broke";
  print_space ();
  print_string "final";
  close_box ();
  print_newline ()
;;

test_print_fits_or_breaks 22;;
test_print_fits_or_breaks 23;;

print_newline ();;

let test_print_pre_break m =
  print_string "margin = ";
  print_int m;
  print_newline ();
  set_margin m;
  open_hvbox 2;
  print_string "before";
  print_space ();
  print_string "after";
  print_space ();
  print_pre_break 2 "pre" 6;
  print_space ();
  print_string "final";
  close_box ();
  print_newline ()
;;

test_print_pre_break 15;;
test_print_pre_break 25;;
