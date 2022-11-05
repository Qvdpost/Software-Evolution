module Syntax

import IO;
import ParseTree;


layout Whitespace = [^\n\t-\n \r \ ]* !>> [^\n\t-\n \r \ ];
lexical IntegerLiteral = [0-9]+ !>> [0-9];

lexical Comment
            = "//" ![\n]* $
            | "/*" ![*/]* "*/"
            ;

start syntax Decls
    = cmnts: Comment
    | integers: IntegerLiteral ";"
    ;

start syntax Prog = prog: Decls* ;
