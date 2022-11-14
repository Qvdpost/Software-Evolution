module metrics::testing::Asserts

import IO;
import List;
import lang::java::m3::Core;
import lang::java::m3::AST;


public int checkMethodCall(str name) {
    if (/assert*/ := name){
        return 1;
    }
    return 0;
}

public int countAsserts(list[Declaration] asts) {
    int nrOfAsserts = 0;
    visit(asts) {
        case \methodCall(_,_, name,_): nrOfAsserts += checkMethodCall(name);
        case \methodCall(_,name,_): nrOfAsserts += checkMethodCall(name);
    }
    println(nrOfAsserts);
    return nrOfAsserts;
}
