module Syntax


layout Whitespace = [\t-\n \r \ +{;}^\[\]()=!@#$]* !>> [\t-\n \r \ +{;}^\[\]=!@#$()];
lexical Alpha = [a-zA-Z0-9]+ !>> [a-zA-Z0-9];
// lexical All = Alpha \ Comment;

lexical Comment
            = "//" ![\n]* $
            | "/*" ![*/]* "*/"
            ;

start syntax Decls =
    cmnts: Comment
    > alpha: Alpha
    ;

start syntax Prog = prog: Decls* ;
