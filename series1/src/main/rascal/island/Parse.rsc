module island::Parse

import island::Syntax;
import ParseTree;

Prog parseExp(loc file) = parse(#start[Prog], file).top;
Prog parseExp(str txt) = parse(#Prog, txt);
