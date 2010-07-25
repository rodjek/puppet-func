(* Func module for Augeas
 Author: Tim Sharpe <tim@sharpe.id.au>

 certmaster.conf and minion.conf are standard INI files.
*)


module Funcminion =
  autoload xfm

(************************************************************************
 * INI File settings
 *************************************************************************)
let comment    = IniFile.comment "#" "#"
let sep        = IniFile.sep "=" "="


(************************************************************************
 *                        ENTRY
 *************************************************************************)
let entry   = IniFile.indented_entry IniFile.entry_re sep comment


(************************************************************************
 *                        RECORD
 *************************************************************************)
let title   = IniFile.indented_title IniFile.record_re
let record  = IniFile.record title entry


(************************************************************************
 *                        LENS & FILTER
 *************************************************************************)
let lns     = IniFile.lns record comment

let filter = incl "/etc/certmaster/minion.conf"

let xfm = transform lns filter
