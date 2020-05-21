(*
   Type definition of a normalized tree-sitter grammar description.
*)

type ident = string

(* See Alias.mli for explanations on tree-sitter aliases. *)
type alias = {
  id: ident;
    (* unique name for the alias, suitable for generating type names and
       function names. *)

  name: ident;
    (* original name of the alias, which may not be unique.
       This is what's exposed in the tree-sitter parser output. *)
}

type rule_body =
  (* atomic (leaves) *)
  | Symbol of (ident * alias option)
     (* reference to a named rule. The optional part is the name shown to us
        in the parsing result due to an ALIAS. *)

  | String of string
     (* constant string as exposed in the parsing output from tree-sitter.
        It is either the result of a STRING or an anonymous ALIAS. *)

  | Pattern of string
  | Blank

  (* composite (nodes) *)
  | Repeat of rule_body
  | Repeat1 of rule_body
  | Choice of rule_body list
  | Optional of rule_body
  | Seq of rule_body list

type rule = {
  name: ident;

  aliases: alias list;
    (* all the aliases for this rule found in the grammar. The alias object
       includes a globally-unique ID to be used as an OCaml type name. *)

  is_rec: bool;
  body: rule_body;
}

type grammar = {
  name: string;
  entrypoint: string;

  rules: rule list list;
    (* rules, grouped and sorted in dependency order. *)
}

(* alias *)
type t = grammar
