(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*             Xavier Leroy, projet Cristal, INRIA Rocquencourt           *)
(*                                                                        *)
(*   Copyright 2002 Institut National de Recherche en Informatique et     *)
(*     en Automatique.                                                    *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

open Misc
open Compile_common

let tool_name = "ocamlc"

let interface = Compile_common.interface ~tool_name

(** Bytecode compilation backend for .ml files. *)

let to_bytecode i (typedtree, coercion) =
  (typedtree, coercion)
  |> Profile.(record transl)
    (Translmod.transl_implementation i.modulename)
  |> Profile.(record ~accumulate:true generate)
    (fun { Lambda.code = lambda; required_globals } ->
       lambda
       |> print_if i.ppf_dump Clflags.dump_rawlambda Printlambda.lambda
       |> Simplif.simplify_lambda i.sourcefile
       |> print_if i.ppf_dump Clflags.dump_lambda Printlambda.lambda
       |> Bytegen.compile_implementation i.modulename
       |> print_if i.ppf_dump Clflags.dump_instr Printinstr.instrlist
       |> fun bytecode -> bytecode, required_globals
    )

let emit_bytecode i (bytecode, required_globals) =
  let cmofile = cmo i in
  let oc = open_out_bin cmofile in
  Misc.try_finally (fun () ->
      bytecode
      |> Profile.(record ~accumulate:true generate)
        (Emitcode.to_file oc i.modulename cmofile ~required_globals);
    )
    ~always:(fun () -> close_out oc)
    ~exceptionally:(fun () -> Misc.remove_file cmofile)

let implementation ~sourcefile ~outputprefix =
  Compmisc.with_ppf_dump ~fileprefix:(outputprefix ^ ".cmo") @@ fun ppf_dump ->
  let info =
    init ppf_dump ~init_path:false ~tool_name ~sourcefile ~outputprefix
  in
  let frontend info = typecheck_impl info @@ parse_impl info in
  let backend info typed = emit_bytecode info @@ to_bytecode info typed in
  wrap_compilation ~frontend ~backend info
