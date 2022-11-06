module Syntax

layout Whitespace = [\t-\ ]* !>> [\t-\ ];

lexical AlphaNumeric = [a-zA-Z0-9]+ !>> [a-zA-Z0-9] ;
lexical NonChars = "{" | "}" | "-" | "+" | "!" | "@" | "#" | "$" | "%"
                | "^" | "&" | "*" | "(" | ")" | "[" | "]" | "|" | "?"
                 | "\<" | "\>"  | "." | "," | "\\" | ";" | ":"| "=" | "~" | "_" | "\t" | " " | "\n" | "\r";

lexical NonChar = NonChars+ !>> NonChars;

lexical Comments
            = "//" ![\n]* $
            | "/*" ![*/]* "*/"
            ;

lexical OtherThenComment
            = AlphaNumeric ![\n]* $
            | NonChars ![\n]* $
            ;

start syntax Decls
    = cmnts: Comments
    | nonComment: OtherThenComment
    ;

start syntax Prog = prog: Decls* ;
