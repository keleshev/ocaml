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

let more_often_immediate a b =
  match a, b with
  | Always, (Unknown | Always_on_64bits)
  | Always_on_64bits, Unknown -> true
  | Unknown, _
  | Always, Always
  | Always_on_64bits, (Always | Always_on_64bits) -> false

let describe = function
  | Unknown -> "not an immediate type"
  | Always -> "always an immediate type"
  | Always_on_64bits -> "only an immediate type on 64 bit platforms"

let of_attributes attrs =
  match
    Builtin_attributes.immediate attrs,
    Builtin_attributes.immediate64 attrs
  with
  | true, _ -> Always
  | false, true -> Always_on_64bits
  | false, false -> Unknown
