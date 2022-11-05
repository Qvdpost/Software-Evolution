module Parse

import Syntax;
import ParseTree;
import IO;


Prog parse(loc l) = parse(#Prog, l);
Prog parse(str s) = parse(#Prog, s);


void main(){
    loc x = |file:///Users/jorrit/Documents/Software-Evolution/jorrit-sandbox/func/src/main/rascal/tst.func|;
    println(parse(x));
}