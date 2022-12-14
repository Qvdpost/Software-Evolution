module metrics::volume::UnitSize


import lang::java::m3::Core;
import lang::java::m3::AST;
import lib::Common;
import metrics::volume::LoC;
import Map;
import IO;

// For each method count the lines of codes
public map[loc, int] countMethodLoC(list[Declaration] asts){
    map[loc, int] methodSizes = ();

	visit(asts) {
		case decl: \method(Type _, _, _, _, _): {
			methodSizes[decl.src] = countLoC(getIslandASTsFromFile(decl.src));
		}
		case decl: \method(Type _, _, _, _): {
			methodSizes[decl.src] = countLoC(getIslandASTsFromFile(decl.src));
		}
	}

    return methodSizes;
}

public tuple[map[str, num],str] getUnitVolumeRiskProfile(list[Declaration] asts) {

	map[loc, int] unit_sizes = countMethodLoC(asts);
    int nrOfMethods = size(unit_sizes);
    map[str, real] riskProfile = getRiskProfile();

	for (unit <- unit_sizes) {

		if (unit_sizes[unit] <= 20) {
			riskProfile["low"] += 1.0;
        } else if (unit_sizes[unit] <= 30) {
			riskProfile["moderate"] += 1.0;
		} else if (unit_sizes[unit] <= 40) {
			riskProfile["high"] += 1.0;
		} else {
			riskProfile["very_high"] += 1.0;
		}
    }

	map[str, num] relative_risks = (unit: getPercentage(riskProfile[unit],nrOfMethods) | unit <- riskProfile);

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
