module Parse

import Syntax;
import ParseTree;
import IO;

// Prog parseExp(loc file) = parse(#Prog, file, allowAmbiguity=true);
Prog parseExp(loc file) = parse(#Prog, file);
Prog parseExp(str txt) = parse(#Prog, txt);
