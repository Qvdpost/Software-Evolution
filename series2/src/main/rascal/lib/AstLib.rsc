module lib::AstLib


import lang::java::m3::Core;
import lang::java::m3::AST;
import lib::Common;

import IO;


public list[Declaration] getMethodAst(list[Declaration] asts){
    list[Declaration] methodAst = [];

	visit(asts) {
		case meth: \method( _, str name, _, _, _): methodAst = methodAst + meth;
        case meth: \method(_, str name, _, _): methodAst = methodAst + meth;
	}

    return methodAst;
}