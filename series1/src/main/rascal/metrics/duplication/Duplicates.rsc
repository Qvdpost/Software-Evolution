module metrics::duplication::Duplicates

import metrics::volume::LoC;
import island::AST;


import IO;
import Map;

map[str, set[loc]] initOrIncrMap(map[str, set[loc]] mapping, str key, loc val) {
	if (key in mapping) {mapping[key] += val;}
	else { mapping[key] = {val};}

	return mapping;
}

void main() {
    loc project = |project://sampleJava|;

    list[island::AST::Prog] asts = getIslandASTsFromProject(project);

	map[str, set[loc]] occurrences = ();

    for (line <- getLoC(asts[0])) {
        occurrences = initOrIncrMap(occurrences, line.text, line.src);
    }

    println(occurrences);
}