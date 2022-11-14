module metrics::complexity::Cyclomatic

import IO;
import Set;
import List;
import Map;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lib::Common;

import metrics::volume::LoC;
import metrics::volume::UnitSize;

/*
 * Unit complexity: uses cyclomatic complexity (McCabe)
 * M = E - N + 2P
 * In Java (simplified):
 *
 * Start with a count of one for the method.
 *
 * Category		+= 1 for each:
 * ==============================================
 * Returns 		return that isn't the last statement of a method.
 * Selection 	if, else, case, default.
 * Loops 		for, while, do-while, break, and continue.
 * Operators 	&&, ||, ?, and :
 * Exceptions	catch, finally, throw, or throws clause.
 *
 * - https://www.theserverside.com/feature/How-to-calculate-McCabe-cyclomatic-complexity-in-Java
 *
 */
int cyclomaticComplexity(M3 ast) {

	int complexity = 1;
	bool firstReturn = true;

	visit(ast) {
		case \return(_): {
			if (!firstReturn) complexity += 1;
			else firstReturn = false;
		}
		case \if(_, _): complexity += 1;
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

public map[loc, int] unitComplexity(loc projectLocation) {
	set[loc] methods = getMethods(projectLocation);
	map[loc, int] result = ();

	visit (methods) {
        case currentMethod: loc _ :  result[currentMethod] = cyclomaticComplexity(createM3FromFile(currentMethod));
    }

	return result;
}

public tuple[map[str, num],str] complexityRank(int lines_of_code, loc project) {
    map[str, real] risks = getRiskProfile();


	map[loc, int] unit_sizes = countMethodLoC(project);

	map[loc, int] unit_complexities = unitComplexity(project);

	for (unit <- unit_complexities) {
		if (unit_complexities[unit] <= 10) {
			risks["low"] += unit_sizes[unit];
		} else if (unit_complexities[unit] <= 20) {
			risks["moderate"] += unit_sizes[unit];
		} else if (unit_complexities[unit] <= 50) {
			risks["high"] += unit_sizes[unit];
		} else {
			risks["very_high"] += unit_sizes[unit];
		}
	}

	map[str, num] relative_risks = (unit: (risks[unit]/lines_of_code) * 100 | unit <-risks);

    list[tuple[num, num, num, str]] rankings = getRankings();

	for (rank <- rankings) {
		if (relative_risks["moderate"] <= rank[0]
			&& relative_risks["high"] <= rank[1]
			&& relative_risks["very_high"] <= rank[2]) {

			return <relative_risks, rank[3]>;
		}
	}

	return "Error";
}
