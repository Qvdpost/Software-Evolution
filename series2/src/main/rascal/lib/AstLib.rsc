module lib::AstLib


import lang::java::m3::Core;
import lang::java::m3::AST;
import lib::Common;


public list[node] getMethodAst(list[Declaration] asts){
    list[node] methodAst = [];

	visit(asts) {
		case meth: \method( _, _, _, _, _): methodAst = methodAst + meth;
        case meth: \method(_, _, _, _): methodAst = methodAst + meth;
        // case meth: \method: methodAst = methodAst + meth;
	}

    return methodAst;
}
