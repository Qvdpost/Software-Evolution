module metrics::testing::Asserts

import IO;
import List;
import Map;
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

public tuple[real, str] countMethodsInTests(M3 originalModel, list[Declaration] asts) {
    set[str] testFileSet = { file.path | file <- files(originalModel),  /Test*/ := file.file};

    map[str, int] methodCalls = ();


    visit(asts) {
		case decl: \method(Type _, name, _, _, _): {
            if (decl.src.path notin testFileSet) {
                methodCalls[decl.src.file + "." + name] = 0;
            }
        }
        case decl: \method(Type _, name, _, _): {
            if (decl.src.path notin testFileSet) {
                methodCalls[decl.src.file+"."+name] = 0;
            }
        }
	}


    visit(asts) {
        case call: \methodCall(_, name:\simpleName(_), methodName,_): {
            if (call.src.path in testFileSet && name.typ != unresolved() && name.typ.decl?) {
                methodCalls[name.typ.decl.file + ".java." + methodName] ? 0 += 1;
            }
        }
        case call: \methodCall(_, methodName, _): {
            if (call.src.path in testFileSet && call.typ != unresolved() && call.typ.decl?) {
                methodCalls[call.typ.decl.file + ".java." + methodName] ? 0 += 1;
            }
        }
    }

    map[str, int] methodCallsInTest = ();

    for (methodCall <- methodCalls) {
        if (methodCalls[methodCall] > 0) {
            methodCallsInTest[methodCall] = methodCalls[methodCall];
        }
    }

    real coverage = getPercentage(size(methodCallsInTest), size(methodCalls));

    for (rank <- getUnitTestCoverageRankings()) {
        if (coverage >= rank[0]) {
            return <getPercentage(size(methodCallsInTest), size(methodCalls)), rank[2]>;
        }
    }

    return <0.0, "error">;
}
