module AST

data Func
     = func(str name, list[str] formals, Exp body)
     ;

data Prog
     = prog(list[Func] funcs)
     ;
