module Syntax

layout Whitespace = [\t-\n\r\ ]*;

lexical IntegerLiteral = [0-9]+;

start syntax Prog = prog: Exp* ;

start syntax Exp
  = integerLiteral: IntegerLiteral
  | bracket "(" Exp ")"
  > left mult: Exp "*" Exp
  > left add: Exp "+" Exp
  ;
