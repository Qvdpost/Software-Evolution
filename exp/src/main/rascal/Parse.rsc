module Parse

import Syntax;
import ParseTree;

Prog parse(loc l) = parse(#start[Prog], l).top;
Prog parse(str s) = parse(#start[Prog], s).top;
