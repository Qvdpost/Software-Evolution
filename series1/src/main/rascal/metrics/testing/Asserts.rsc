module metrics::testing::Asserts

import IO;
import List;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lib::Common;
import Set;


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

    return nrOfAsserts;
}

public real countMethodsInTests(loc project, M3 originalModel) {
    set[loc] testFileSet = { file | file <- files(originalModel),  /Test*/ := file.file};
    <model, testAst> = getFilesetASTs(project, testFileSet);

    set[loc] allMethods = methods(originalModel);
    set[loc] methodCallsInTests = {};

    visit(testAst) {
        case call: \methodCall(_,_,_,_): methodCallsInTests += call.decl;
        case call: \methodCall(_,_,_): methodCallsInTests += call.decl;
    }

    return getPercentage(size(methodCallsInTests), size(allMethods));
}
