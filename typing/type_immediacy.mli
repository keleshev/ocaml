(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*                   Jeremie Dimino, Jane Street Europe                   *)
(*                                                                        *)
(*   Copyright 2019 Jane Street Group LLC                                 *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

(** Immediacy status of a type *)

type t =
  | Unknown
  | Always
  | Always_on_64bits

type mismatch =
  | Immediate_mismatch
  | Immediate64_mismatch

(** TODO *)
val detect_mismatch : t -> t -> mismatch option

(** Return the immediateness of a type as indicated by the user via
    attributes *)
val of_attributes : Parsetree.attributes -> t
