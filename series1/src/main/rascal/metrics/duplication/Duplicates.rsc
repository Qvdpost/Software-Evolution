module metrics::duplication::Duplicates

import metrics::volume::LoC;
import island::AST;


import IO;
import List;
import Set;
import Location;

map[str, set[loc]] initOrIncrMap(map[str, set[loc]] mapping, str key, loc val) {
	if (key in mapping) {mapping[key] += val;}
	else { mapping[key] = {val};}

	return mapping;
}

list[Decls] getNLoC(list[Decls] LoC, int init, int step) {
    return slice(LoC, init, step);
}

str concatLoC(list[Decls] LoC) {
    return ("" | it + e | str e <- [ line.text | line <- LoC]);
}

loc coverBlock(list[Decls] LoC) {
    return cover([line.src | line <- LoC]);
}

void main() {
    loc project = |project://sampleJava|;

    list[island::AST::Prog] asts = getIslandASTsFromProject(project);

	map[str, set[loc]] occurrences = ();

    for (ast <- asts) {
        list[Decls] LoC = getLoC(ast);

        int fileLoC = size(LoC);

        println(fileLoC);

        if (fileLoC < 6) {
            return;
        }
        for (init <- [0 .. fileLoC]) {
            for (step <- [6 .. fileLoC - init + 1], fileLoC - init >= 6) {
                block = getNLoC(LoC, init, step);
                occurrences = initOrIncrMap(occurrences, concatLoC(block), coverBlock(block));
            }
        }
    }


    for (block <- occurrences) {
        if (size(occurrences[block]) > 1) {
            println("<block> \n occurs at: \n <occurrences[block]>");
        }
    }

}