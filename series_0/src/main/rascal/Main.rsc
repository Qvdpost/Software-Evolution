module Main

import lang::java::m3::Core;
import lang::java::m3::AST;

import IO;
import List;
import Set;
import String;

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
	}
	return fors;
}

tuple[int, list[str]] mostOccurrences(map[str, int] mapping) {

	max_occurrence = 0;
	for (key <- mapping) {
		if (mapping[key] > max_occurrence) {
			max_occurrence = mapping[key];
		}
	}

	return <max_occurrence, [key | key <- mapping, mapping[key] == max_occurrence]>;
}

map[str, int] initOrIncrMap(map[str, int] mapping, str key) {
	if (key in mapping) {mapping[key] += 1;}
	else { mapping[key] = 0;}

	return mapping;
}

tuple[int, list[str]] mostOccurringVariable(list[Declaration] asts){
	map [str, int] varMap = ();
	visit(asts){
		case \variable(name, _): varMap = initOrIncrMap(varMap, name);
		case \variable(name, _, _): varMap = initOrIncrMap(varMap, name);
	}

	return mostOccurrences(varMap);
}

tuple[int, list[str]] mostOccurringNumber(list[Declaration] asts){
	map [str, int] varMap = ();
	visit(asts){
		case \characterLiteral(name): varMap = initOrIncrMap(varMap, name);
		case \booleanLiteral(true): varMap = initOrIncrMap(varMap, "Bool: true");
		case \booleanLiteral(false): varMap = initOrIncrMap(varMap, "Bool: false");
		case \stringLiteral(name): varMap = initOrIncrMap(varMap, name);
	}

	return mostOccurrences(varMap);
}

list[loc] findNullReturned(list[Declaration] asts){
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
    println("Hello Rascal");
}

