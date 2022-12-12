module metrics::duplication::Preprocessing

import lang::java::m3::Core;
import lang::java::m3::AST;
import lib::Common;
import lib::Debug;
import lib::AstLib;

import IO;
import Node;

bool isVarType(Expression expr) {
	if (expr.decl.scheme == "java+variable")
		return true;

	if (expr.decl.scheme == "java+field")
		return true;

	if (\variable(_, _) := expr)
		return true;

	return false;
}

str typToString(TypeSymbol typ) {
	switch (typ) {
		case \class(_, _): return "class";
  		case \interface(_, _): return "interface";
  		case \enum(_): return "enum";
  		case \method(_, _, _, _): return "method";
  		case \constructor(_, _): return "cons";
  		case \typeParameter(_, _): "typeParam";
  		case \typeArgument(_): return "typeArg";
  		case \wildcard(_): return "wildcard";
  		case \capture(_, _): return "capture";
  		case \intersection(_): return "intersection";
  		case \union(_): return "union";
  		case \object(): return "object";
  		case \int(): return "int";
  		case \float(): return "float";
  		case \double(): return "double";
  		case \short(): return "short";
  		case \boolean(): return "bool";
  		case \char(): return "char";
  		case \byte(): return "byte";
  		case \long(): return "long";
  		case \void(): return "void";
  		case \null(): return "null";
  		case \array(_, _): return "array";
  		case \typeVariable(_): return "typeVar";
  		case \unresolved(): return "unresolved";
		default: return "unknown";
	}
	return "";
}

str replaceVarName(str word, Expression expr) {
	if (\qualifiedName(_, _) := expr)
		return "__qualifiedName__";

	switch (expr.typ) {
		case \int(): return "__" + typToString(expr.typ) + "__";
		case \float(): return "__" + typToString(expr.typ) + "__";
		case \double(): return "__" + typToString(expr.typ) + "__";
		case \short(): return "__" + typToString(expr.typ) + "__";
		case \boolean(): return "__" + typToString(expr.typ) + "__";
		case \char(): return "__" + typToString(expr.typ) + "__";
		case \byte(): return "__" + typToString(expr.typ) + "__";
		case \long(): return "__" + typToString(expr.typ) + "__";
		case \null(): return "__" + typToString(expr.typ) + "__";
		case \array(_, _): return "__" + typToString(expr.typ) + "__";
        case \class(decl, _): return "__" + decl.path + "__";
	}

	return "__" + word + "__";
}

Expression anonymizeVar(Expression expr) {
    switch (expr) {
        case \variable(name, _): expr.name = replaceVarName(name, expr);
        case \variable(name, _, _): expr.name = replaceVarName(name, expr);
    }

	return expr;
}

Expression emptyLiteral(Expression literal) {
    switch (literal) {
        case \stringLiteral(_): literal.stringValue = "";
        case \characterLiteral(_): literal.charValue = "";
        case \number(_): literal.numberValue = "0";
    }

    return literal;
}

Expression rewriteExpr(Expression expr, map[str, int] var_occurrence) {

    switch (expr) {
        case \variable(name, _): expr.name = "<var_occurrence[name]?"">" + replaceVarName(name, expr);
        case \variable(name, _, _): expr.name = "<var_occurrence[name]?"">" + replaceVarName(name, expr);
		case \simpleName(name): expr.name = "<var_occurrence[name]?"">" + replaceVarName(name, expr);
        case literal: \stringLiteral(_): return emptyLiteral(literal);
        case literal: \characterLiteral(_): return emptyLiteral(literal);
        case literal: \number(_): return emptyLiteral(literal);
    }

    return expr;
}

Declaration rewriteDecl(Declaration decl, map[str, int] var_occurrence) {
    switch (decl) {
        case \parameter(\simpleType(paramType), name, _): decl.name = "<var_occurrence[name]?"">" + replaceVarName(name, paramType);
    }
    return decl;
}


list[Declaration] rewriteAST(list[Declaration] asts) {
	list[Declaration] result = [];
	// Modify ast for clone detection.
	for (ast <- asts) {
		int var_count = 0;
		map[str, int] var_occurrence = ();
		// visit (ast) {
		// 	case \variable(name, _): { if (name notin var_occurrence) { var_occurrence[name] = var_count; var_count += 1; } }
		// 	case \variable(name, _, _): { if (name notin var_occurrence) { var_occurrence[name] = var_count; var_count += 1; } }
		// 	// case \simpleName(name): { if (name notin var_occurrence) { var_occurrence[name] = var_count; var_count += 1; } }
		// 	case \parameter(_, name, _): { if (name notin var_occurrence) { var_occurrence[name] = var_count; var_count += 1; } }
		// }

		result += visit(ast){
			case \Expression expr => rewriteExpr(expr, var_occurrence)
			case \Declaration decl => rewriteDecl(decl, var_occurrence)
		}
	}


    return result;
}