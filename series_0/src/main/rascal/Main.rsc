module Main

import lang::java::m3::Core;
import lang::java::m3::AST;

import IO;
import List;
import Map;
import Set;


list[Declaration] getASTs(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[Declaration] asts = [createAstFromFile(f, true)
        | f <- files(model.containment), isCompilationUnit(f)];
    return asts;
}

int getNumberOfInterfaces(list[Declaration] asts){
    int interfaces = 0;
    visit(asts){
        case \interface(_, _, _, _): interfaces += 1;
    }
    return interfaces;
}

int getNumberOfForLoops(list[Declaration] asts){
	int fors = 0;
	visit(asts){
		case \for(_, _, _): fors += 1;
		case \for(_, _, _, _): fors += 1;
		case \foreach(_, _, _): fors += 1;
	}
	return fors;
}

tuple[int, list[str]] mostOccurrences(map[str, int] mapping) {

	inverse = invert(mapping);
	max_occurrence = max(domain(inverse));
	return <max_occurrence, toList(inverse[max_occurrence])>;
}

map[str, int] initOrIncrMap(map[str, int] mapping, str key) {
	if (key in mapping) {mapping[key] += 1;}
	else { mapping[key] = 1;}

	return mapping;
}

map[str, int] incrMap(map[str, int] mapping, str key) {
	if (key in mapping) {mapping[key] += 1;}

	return mapping;
}

tuple[int, list[str]] mostOccurringVariable(list[Declaration] asts) {
	map [str, int] varMap = ();
	visit(asts){
		case \variable(name, _): varMap = initOrIncrMap(varMap, name);
		case \variable(name, _, _): varMap = initOrIncrMap(varMap, name);
		case \parameter(_, str name, _): varMap = initOrIncrMap(varMap, name);
		case \vararg(_, str name): varMap = initOrIncrMap(varMap, name);
		case \simpleName(name): varMap = incrMap(varMap, name);
	}

	return mostOccurrences(varMap);
}

tuple[int, list[str]] mostOccurringNumber(list[Declaration] asts) {
	map [str, int] varMap = ();
	visit(asts){
		case \characterLiteral(name): varMap = initOrIncrMap(varMap, name);
		case \booleanLiteral(true): varMap = initOrIncrMap(varMap, "Bool: true");
		case \booleanLiteral(false): varMap = initOrIncrMap(varMap, "Bool: false");
		case \stringLiteral(name): varMap = initOrIncrMap(varMap, name);
	}

	return mostOccurrences(varMap);
}

list[loc] findNullReturned(list[Declaration] asts) {
	list[loc] locs = [];
	visit(asts){
		case \return(expr): {
			if (expr.typ == \null()) locs += expr.src;
		}
	}

	return locs;
}

test bool numberOfInterfaces() {
	return getNumberOfInterfaces(getASTs(|project://smallsql0.21_src|)) == 1;
}

void main() {
	asts = getASTs(|project://smallsql0.21_src|);
	println(mostOccurringVariable(asts));
	println(mostOccurringNumber(asts));
}
