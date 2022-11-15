module metrics::duplication::Duplicates

import metrics::volume::LoC;
import island::AST;
import lib::Common;

import IO;
import List;
import Set;
import Map;
import Location;

map[str, set[loc]] initOrIncrMap(map[str, set[loc]] mapping, str key, loc val) {
	if (key in mapping) {mapping[key] += val;}
	else { mapping[key] = {val};}

	return mapping;
}

map[str, set[loc]] filterValMap(map[str, set[loc]] mapping, str key, loc val) {
	if (key in mapping) {mapping[key] -= val;}

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

map[str, set[loc]] getBlocksOfN(map[str, set[loc]] occurrences, list[island::AST::Prog] asts, int N) {
    for (ast <- asts) {
        list[Decls] LoC = getLoC(ast);

        int fileLoC = size(LoC);

        if (fileLoC < N) {
            continue;
        }

        for (init <- [0 .. fileLoC - N + 1]) {
            block = slice(LoC, init, N);
            occurrences = initOrIncrMap(occurrences, ("" | it + e | str e <- [ line.text | line <- block]), cover([line.src | line <- block]));
        }
    }
    return occurrences;
}

map[str, map[loc, str]] explodeDuplicates(map[set[loc], str] duplicates) {
    map[str, map[loc, str]] result = ();
    for (locs <- duplicates) {
        for (src <- locs) {
            if (src.file notin result) {
                result[src.file] = ();
            }
            result[src.file][src] = duplicates[locs];
        }
    }
    return result;
}

map[str, set[loc]] getDuplicates(map[str, set[loc]] occurrences, int treshold) {
    map[str, set[loc]] result = ();
    for (block <- occurrences) {
        if (size(occurrences[block]) > treshold) {
            result[block] = occurrences[block];
        }
    }
    return result;
}

str merge(str l, str r) {


    for ([*head, *l, *_] := r)
    {
        println("gotcha at <size(head)>");
    }
}

map[str, set[loc]] mergeBlocks(map[str, set[loc]] duplicates) {

    map[set[loc], str] invertedDuplicates = invertUnique(duplicates);
    map[str, map[loc, str]] explodedInvertedDuplicates = explodeDuplicates(invertedDuplicates);

    // Bubble sort like algorithm to merge overlapping blocks of code.
    for (srcFile <- explodedInvertedDuplicates) {

        // Sorts the occurrences of codeblocks by order of appearance to more easily find overlap
        list[loc] srcs = sort(domain(explodedInvertedDuplicates[srcFile]), beginsBefore);
        int merged = 0;

        do {
            merged = 0;
            for (init <- [0 .. size(srcs) - 1], init < size(srcs) - 1 - merged) {
                list[loc] pair = slice(srcs, init, 2);

                if (isOverlapping(pair[0], pair[1])) {
                    // Refresh the sources to reflect merging of a pair of locs
                    srcs = srcs[0 .. init] + [cover(pair)] + srcs[init + 2 .. ];

                    str block = ("" | it + e | str e <- [ line.text | line <- getLoC(getIslandASTsFromFile(cover(pair)))]);

                    // Adds the new block of code to the exploded duplicate blocks
                    explodedInvertedDuplicates[srcFile][cover(pair)] = block;

                    // TODO: Check of het mergen niet blokjes overslaat die ook een clone class kunnen opleveren. eg. index 2-3 samen.

                    // Filters values of merged sources from original duplicates
                    duplicates[explodedInvertedDuplicates[srcFile][pair[0]]] -= pair[0];
                    duplicates[explodedInvertedDuplicates[srcFile][pair[1]]] -= pair[1];

                    // Adds the new block to the original duplicates
                    duplicates = initOrIncrMap(duplicates, block, cover(pair));
                    merged += 1;
                }
            }
        } while (merged > 0);
    }
    return duplicates;
}

tuple[int, int, str] duplicationRank(loc project) {
    // loc project = |project://sampleJava|;
    // loc project = |project://smallsql0.21_src|;

    tuple[int count, str _] projectLoC = mainLoC(project);

    list[island::AST::Prog] asts = getIslandASTsFromProject(project);

	map[str, set[loc]] occurrences = ();

    occurrences = getBlocksOfN(occurrences, asts, 6);

    map[str, set[loc]] duplicates = getDuplicates(occurrences, 1);

    duplicates = mergeBlocks(duplicates);

    map[str, set[loc]] duplicateBlocks = getDuplicates(duplicates, 0);

    int duplicateLoC = 0;
    for (clone <- duplicateBlocks) {
        for (src <- duplicateBlocks[clone]) {
            duplicateLoC += countLoC(src);
        }
    }

    // TODO: Series 2: voor elke originele code class met nog maar 1 element -> zoek in backup van originele code class naar de andere dupolicates en herstel de code class

    int relDuplicateLoC = percent(duplicateLoC, projectLoC.count);

    for (rank <- getDuplicationRankings()) {
        if (relDuplicateLoC <= rank[1]) {
            return <duplicateLoC, relDuplicateLoC, rank[2]>;
        }
    }

    return <0, 0, "error">;
}