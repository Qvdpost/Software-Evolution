module AST

import Syntax;

data Exp
    = integerLiteral (str i)
    | add(Exp lhs, Exp rhs)
    | mult(Exp lhs, Exp rhs)
    ;

data Prog
     = prog(list[Exp] exps)
     ;
