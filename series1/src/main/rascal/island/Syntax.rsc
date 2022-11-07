module island::Syntax

layout Whitespace = [\t-\ ]* !>> [\t-\ ];

lexical AlphaNumeric = [a-zA-Z0-9]+ !>> [a-zA-Z0-9] ;

lexical NonChars = "{" | "}" | "-" | "+" | "!" | "@" | "#" | "$" | "%"
                 | "^" | "&" | "*" | "(" | ")" | "[" | "]" | "|" | "?"
                 | "\<" | "\>"  | "." | "," | "\\" | ";" | ":"| "="
                 | "~" | "_" | "\t" | " " | "\r" | "\"" | "\'"
                 | "/" !>> [* /];

lexical NonChar = NonChars+ !>> NonChars;

lexical EOLCommentChars =
  ![\n \a0D]*
  ;

lexical EndOfFile =

  ;

lexical LineTerminator =
  [\n]
  | EndOfFile !>> ![]
  | [\a0D] [\n]
  | CarriageReturn !>> [\n]
  ;

lexical CarriageReturn =
  [\a0D]
  ;

// Borrowed from lang::java::Syntax
lexical Comment =
  "/**/"
  | "//" EOLCommentChars !>> ![\n \a0D] LineTerminator
  | "/*" !>> [*] CommentPart* "*/"
  | "/**" !>> [/] CommentPart* "*/"
  ;

lexical UnicodeEscape =
   unicodeEscape: "\\" [u]+ [0-9 A-F a-f] [0-9 A-F a-f] [0-9 A-F a-f] [0-9 A-F a-f]
  ;

lexical BlockCommentChars =
  ![* \\]+
  ;

lexical EscChar =
  "\\"
  ;

lexical EscEscChar =
  "\\\\"
  ;

lexical Asterisk =
  "*"
  ;

lexical CommentPart =
  UnicodeEscape
  | BlockCommentChars !>> ![* \\]
  | EscChar !>> [\\ u]
  | Asterisk !>> [/]
  | EscEscChar
  ;

lexical OtherThenComment
            = AlphaNumeric ![\n]* $
            | NonChars ![\n]* $
            ;

syntax Decls
    = cmnts: Comment
    | nonComment: OtherThenComment
    ;

start syntax Prog = prog: Decls+;
