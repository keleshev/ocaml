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

(** [more_often_immediate a b] returns [true] iff [a] is immediate in
    as many or more cases than [b]. For instance, [Always] is more
    often immediate than [Always_on_64bits]. *)
val more_often_immediate : t -> t -> bool

(** Return a description of the immediacy status of a type, such as
    "always an immediate type" or "only an immediate type on 64 bit
    platforms". *)
val describe : t -> string

(** Return the immediateness of a type as indicated by the user via
    attributes *)
val of_attributes : Parsetree.attributes -> t
