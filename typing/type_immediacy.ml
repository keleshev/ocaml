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

type t =
  | Unknown
  | Always
  | Always_on_64bits

type mismatch =
  | Immediate_mismatch
  | Immediate64_mismatch

let detect_mismatch a b =
  match a, b with
  | Always, (Unknown | Always_on_64bits) -> Some Immediate_mismatch
  | Always_on_64bits, Unknown -> Some Immediate64_mismatch
  | Unknown, _
  | Always, Always
  | Always_on_64bits, (Always | Always_on_64bits) -> None

let of_attributes attrs =
  match
    Builtin_attributes.immediate attrs,
    Builtin_attributes.immediate64 attrs
  with
  | true, _ -> Always
  | false, true -> Always_on_64bits
  | false, false -> Unknown
