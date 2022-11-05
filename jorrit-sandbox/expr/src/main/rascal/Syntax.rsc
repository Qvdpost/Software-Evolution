module Syntax

import IO;
import ParseTree;


layout Whitespace = [\t-\n\r\ ]*;

lexical IntegerLiteral = [0-9]+ !>> [0-9];

// Ambiguous:
// lexical Rest = ![] ;

lexical Comment
            = "//" ![\n]* $
            | "/*" ![*/]* "*/"
            ;

start syntax Decls
    = cmnts: Comment
    > integers: IntegerLiteral
    ;

start syntax Prog = prog: Decls* ;

// lexical Cmt = "%%" ![\n]* $;
// lexical All = [.*]* !>> [.*]*;
// lexical All = ![\n]* $;

