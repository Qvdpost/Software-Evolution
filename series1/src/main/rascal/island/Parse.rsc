module island::Parse

import island::Syntax;
import ParseTree;
import IO;

// Prog parseExp(loc file) = parse(#Prog, file, allowAmbiguity=true);
Prog parseExp(loc file) = parse(#start[Prog], file).top;
Prog parseExp(str txt) = parse(#Prog, txt);
