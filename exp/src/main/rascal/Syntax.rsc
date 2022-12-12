module Syntax

lexical LAYOUT =
  [\t-\n \a0C-\a0D \ ]
  | Comment
  ;

layout LAYOUTLIST  =
  LAYOUT* !>> [\t-\n \a0C-\a0D \ ] !>> (  [/]  [*]  ) !>> (  [/]  [/]  ) !>> "/*" !>> "//"
  ;

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


lexical IntegerLiteral = [0-9]+;

lexical LoC = ![Comment]+ !>> [Comment] [LineTerminator EndOfFile];

start syntax Prog = prog: LoC* ;


// start syntax Exp
//   = integerLiteral: IntegerLiteral
//   | bracket "(" Exp ")"
//   > left mult: Exp "*" Exp
//   > left add: Exp "+" Exp
//   ;
