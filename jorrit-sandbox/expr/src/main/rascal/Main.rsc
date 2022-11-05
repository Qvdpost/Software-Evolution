module Main

import Load;
import AST;
import IO;
// import Parse;

int countComments(Prog asts) {
    int nrOfComments = 0;

    visit(asts) {
        case \cmnts(_): nrOfComments += 1;
    }

    return nrOfComments;
}

void main(){
    loc x = |file:///Users/jorrit/Documents/Software-Evolution/jorrit-sandbox/expr/src/main/rascal/test.txt|;
    loc astfile = |file:///Users/jorrit/Documents/Software-Evolution/jorrit-sandbox/expr/src/main/rascal/ast.json|;
    println(parseExp(x));
    // Prog asts = load(x);

    // println(countComments(asts));
    // writeFile(astfile,asts);
}