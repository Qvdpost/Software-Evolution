module Syntax

layout Whitespace = [\t-\n\r\ ]*;

lexical IntegerLiteral = [0-9]+;

// !>> Is not followed by ..
// lexical Ident =  [a-zA-Z][a-zA-Z0-9]* !>> [a-zA-Z0-9];
lexical Comment = "//";
lexical AnythingExceptQuote = ![\"];
start syntax Prog = prog: Exp* ;

start syntax Exp
  = integerLiteral: IntegerLiteral
  | Comment
  | bracket "(" Exp ")"
  > left mult: Exp "*" Exp
  > left add: Exp "+" Exp
  ;

// syntax Func = func: Ident name "()" "{" list[Exp]"}";
