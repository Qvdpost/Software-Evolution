module AST

import Syntax;

data Decls
    = cmnts(str i)
    | nonComment(str i)
    ;

data Prog
     = prog(list[Decls] decls)
     ;
