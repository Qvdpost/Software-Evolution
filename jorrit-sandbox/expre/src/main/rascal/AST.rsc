module AST

import Syntax;

data Decls
    = alpha(str i)
    | cmnts(str f)
    | EOF(str f)
    ;

data Prog
     = prog(list[Decls] decls)
     ;
