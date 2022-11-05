module AST

import Syntax;

data Decls
    = integers(str i)
    | cmnts(str f)
    ;

data Prog
     = prog(list[Decls] decls)
     ;
