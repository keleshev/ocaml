let set_margin n =
  Format.set_margin n;
  Format.set_max_indent (n - 1)

open Format;;

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

let test_print_break_or_string_if_newline m =
  print_string "margin = ";
  print_int m;
  print_newline ();
  set_margin m;
  open_hvbox 2;
  print_string "before";
  print_space ();
  print_break_or_string_if_newline 1 0 "broke ";
  print_string "after";
  print_space ();
  print_string "final";
  close_box ();
  print_newline ()
;;

test_print_break_or_string_if_newline 19;;
test_print_break_or_string_if_newline 20;;

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
