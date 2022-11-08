module metrics::complexity::Cyclomatic

import IO;
import Set;
import List;
import Map;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import metrics::volume::LoC;

/*
 * Unit complexity: uses cyclomatic complexity
 * M = E - N + 2P
 * In Java:
 * - https://perso.ensta-paris.fr/~diam/java/online/notes-java/principles_and_practices/complexity/complexity-java-method.html
 *
 * Start with a count of one for the method.
 *
 * Category		Add one for each of the following
 * ==============================================
 * Returns 		Each return that isn't the last statement of a method.
 * Selection 	if, else, case, default.
 * Loops 		for, while, do-while, break, and continue.
 * Operators 	&&, ||, ?, and :
 * Exceptions	catch, finally, throw, or throws clause.
 *
 * - https://www.theserverside.com/feature/How-to-calculate-McCabe-cyclomatic-complexity-in-Java
 *
 * How did we check it?? Using example functions and the PMD tool in Eclipse.
 */
int cyclomaticComplexity(Declaration decl) {
	int complexity = 1;
	bool firstReturn = true;

	visit(decl) {
		case \return(_): {
			if (!firstReturn) complexity += 1;
			else firstReturn = false;
		}
		case \if(_, _): complexity += 1;
		// Initial thoughts:
		// We need to add 2, because it contains an else as well.
		// Turns out to be incorrect, though. Just add one.
		case \if(_, _, _): complexity += 1;
		case \case(_): complexity += 1;
		case \defaultCase(): complexity += 1;
		case \foreach(_, _, _): complexity += 1;
		case \for(_, _, _): complexity += 1;
		case \for(_, _, _, _): complexity += 1;
		case \while(_, _): complexity += 1;
		case \do(_, _): complexity += 1;
		case \break(): complexity += 1;
		case \break(_): complexity += 1;
		case \continue(): complexity += 1;
		case \continue(_): complexity += 1;
		case \infix(_, op, _): {
			if (op == "&&" || op == "||") complexity += 1;
		}
		case \conditional(_, _, _): complexity += 1;
		case \catch(_, _): complexity += 1;
		case \throw(_): complexity += 1;
	}

	return complexity;
}


list[Declaration] getMethods(list[Declaration] asts) {
	list[Declaration] methods = [];

	visit(asts) {
		case method:\method(_, _, _, _, _): methods += method;
	}

	return methods;
}

map[Declaration, int] unitComplexity(list[Declaration] subtrees) {
	map[Declaration, int] result = ();
	for (subtree <- subtrees) {
		result[subtree] = cyclomaticComplexity(subtree);
	}
	return result;
}

str complexityRank(list[Declaration] asts) {
	map[str, int] risks = (
		"low": 0,
		"moderate": 0,
		"high": 0,
		"very high": 0
	);

	num lines_of_code = getLOC(asts);

	list[Declaration] units = getMethods(asts);

	map[Declaration, int] unit_sizes = getUnitSize(units);


	map[Declaration, int] unit_complexities = unitComplexity(units);


	for (unit <- unit_complexities) {
		if (unit_complexities[unit] <= 10) {
			risks["low"] += unit_sizes[unit];
		} else if (unit_complexities[unit] <= 20) {
			risks["moderate"] += unit_sizes[unit];
		} else if (unit_complexities[unit] <= 50) {
			risks["high"] += unit_sizes[unit];
		} else {
			risks["very high"] += unit_sizes[unit];
		}
	}

	map[str, num] relative_risks = (unit: (risks[unit]/lines_of_code) * 100 | unit <-risks);

	// Maps values of moderate, high very high
	list[tuple[num, num, num, str]] rankings = [
		<25, 0, 0, "++">,
		<30, 5, 0, "+">,
		<40, 10, 0, "o">,
		<50, 15, 5, "-">,
		<100, 100, 100, "--">
	];

	for (rank <- rankings) {
		if (relative_risks["moderate"] <= rank[0]
			&& relative_risks["high"] <= rank[1]
			&& relative_risks["very high"] <= rank[2]) {

			return rank[3];
		}
	}
	return "Error";
}