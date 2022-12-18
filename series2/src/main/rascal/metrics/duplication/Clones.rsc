module metrics::duplication::Clones

import lang::java::m3::Core;
import lang::java::m3::AST;
import lib::Common;
import metrics::volume::LoC;

import List;
import Set;
import Map;
import Node;
import Location;
import util::Math;

// Add an unset node location to HashMap
map[value, set[loc]] initOrIncrMap(map[value, set[loc]] mapping, node _Node) {
    node unsetNode = unsetRec(_Node);

    if (unsetNode in mapping) mapping[unsetNode] += _Node.src;

	else { mapping[unsetNode] = {_Node.src};}

	return mapping;
}

// Rewrite to lrel datatype as input for the bar charts.
// Uses the total lines of code per clone as key value.
//
// returns sorted lrel
public lrel[int,list[value]] getSlocs(map[value, set[loc]] cloneMap){
    map[int, list[value]] cleanMap = ();
    for (key <- cloneMap){
        for (src <- cloneMap[key]) {
            cleanMap[countLoC(src)] ? [] += [src];
        }
    }
    sortedList = sort(toList(cleanMap));

    return sortedList;
}

// Return the total number of clones for a given clone map
public int getNumberOfClones(map[value, set[loc]] cloneMap){
    int counter = 0;
    for ( key <- cloneMap) {
        for (_ <- cloneMap[key]) {
            counter += 1;
        }
    }
    return counter;
}

// Explodes a map of sets of locations to clones into a single location pointing to that clone.
map[str, map[loc, value]] explodeDuplicates(map[set[loc], value] duplicates) {
    map[str, map[loc, value]] result = ();
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

// Merges overlapping duplicate blocks into largest size clone classes.
map[value, set[loc]] mergeBlocks(map[value, set[loc]] duplicates) {

    map[set[loc], value] invertedDuplicates = invert(duplicates);
    map[str, map[loc, value]] explodedInvertedDuplicates = explodeDuplicates(invertedDuplicates);

    // Bubble sort like algorithm to merge overlapping blocks of code.
    for (srcFile <- explodedInvertedDuplicates) {

        // Sorts the occurrences of codeblocks by order of appearance to more easily find overlap
        list[loc] srcs = sort(domain(explodedInvertedDuplicates[srcFile]), beginsBefore);
        int merged = 0;

        do {
            // Bubble counter
            merged = 0;

            for (init <- [0 .. size(srcs) - 1], init < size(srcs) - 1 - merged) {
                list[loc] pair = slice(srcs, init, 2);

                if (isOverlapping(pair[0], pair[1])) {
                    // Refresh the sources to reflect merging of a pair of locs
                    srcs = srcs[0 .. init] + [cover(pair)] + srcs[init + 2 .. ];

                    list[node] blockStms = [];
                    // Merge the two blocks.
                    if (\block(l) := explodedInvertedDuplicates[srcFile][pair[0]] && \block(r) := explodedInvertedDuplicates[srcFile][pair[1]]) {
                        lh = [];
                        while (!([l*, *rh] := r)) {
                            lh += take(1, l);
                            l = drop(1,l);
                        }
                        blockStms = lh + r;
                    }

                    if (isEmpty(blockStms)) {
                        continue;
                    }

                    newBlock = block(blockStms);
                    // Adds the new block of code to the exploded duplicate blocks
                    explodedInvertedDuplicates[srcFile][cover(pair)] = newBlock;

                    // Filters values of merged sources from original duplicates
                    duplicates[explodedInvertedDuplicates[srcFile][pair[0]]] -= {pair[0]};
                    duplicates[explodedInvertedDuplicates[srcFile][pair[1]]] -= {pair[1]};

                    // Adds the new block to the original duplicates
                    if (newBlock notin duplicates) {
                        duplicates[newBlock] = {cover(pair)};
                    } else {
                        duplicates[newBlock] += cover(pair);
                    }
                    merged += 1;
                }
            }
        } while (merged > 0);
    }
    return duplicates;
}

// Filters clones of size <threshold> in a map of clone to locations.
map[value, set[loc]] getDuplicates(map[value, set[loc]] occurrences, int treshold=1) {
    map[value, set[loc]] result = ();
    for (block <- occurrences) {
        if (size(occurrences[block]) > treshold) {
            result[block] = occurrences[block];
        }
    }
    return result;
}

// Method to get a type-1 or type-2 clone map, based on the type of AST that is given.
//
// Returns a map with as key the unset node of the clone and a svalue a set of the locations of
// that clone.
public map[value, set[loc]] getCloneMap(list[Declaration] asts, int weight) {
    map[value, set[loc]] nodeAst = ();
    list[tuple[value, loc]] subsumptions = [];

    // Add all subtrees to a HashMap starting from a certain weight
    top-down visit(asts) {
        case _Node: \method(_,name,_,_, imp: \block(impl)) : {
            blockSize = size(impl);

            // Add entire methods to the map to find short function clones
            // that would otherwise remain undetected.
            if(_Node.decl?) {
                nodeAst = initOrIncrMap(nodeAst, _Node);
            }

            // Add subsequences of the method body to the HashMap
            for (init <- [0 .. blockSize - 1]) {
                subImpl = slice(impl, init, blockSize - init);
                subNode = block(subImpl);
                subNode.src = imp.src;

                if (subNode.src? && getNumberOfChildNodes(subNode, weight) >= weight) {
                    tempBlock = [head(subImpl)];
                    subImpl = tail(subImpl);
                    tempNode = block(tempBlock);

                    // Aggregate a subsequence of the correct size.
                    while (getNumberOfChildNodes(tempNode, weight) < weight) {
                        tempBlock += [head(subImpl)];
                        subImpl = tail(subImpl);
                        tempNode = block(tempBlock);
                    }

                    tempNode.src = cover([stmt.src | stmt <- tempBlock]);
                    nodeAst = initOrIncrMap(nodeAst, tempNode);

                    // Continue with remaining subsequences.
                    while (subImpl != []) {
                        tempBlock += [head(subImpl)];
                        subImpl = tail(subImpl);
                        tempNode = block(tempBlock);
                        tempNode.src = cover([stmt.src | stmt <- tempBlock]);
                        nodeAst = initOrIncrMap(nodeAst, tempNode);
                    }
                }
            }
        }
    }

    nodeAst = getDuplicates(nodeAst);

    nodeAst = mergeBlocks(nodeAst);

    // Check for subsumption, add subsumptions to a list to remove later
    // altering the HashMap in the same loop didn't seem to work correctly.
    for ( key <- nodeAst) {
        if (size(nodeAst[key]) > 1) {
            for (source <- nodeAst[key]) {
                // loop again over the same map
                for ( keyTwo <- nodeAst) {
                    if (size(nodeAst[keyTwo]) > 1) {
                        for (src <- nodeAst[keyTwo]) {
                            if(isStrictlyContainedIn(source, src)) {
                                subsumptions += <key, source>;
                                break;
                            }
                        }
                    }
                }
            }
        }
    }

    // Remove all subsumptions from the tree
    for (tuple[value n, loc src] sub <- subsumptions) {
        nodeAst[unsetRec(sub.n)] -= {sub.src};
    }

    return nodeAst;
}

// Convert given sorted lrel datatype to readable import for the Rascal Graph
// functionality
public rel[str, int] convertToCharData(lrel[int,list[value]] cloneList){
    // Needed to initialize with a value..
    barChartData = {<"",0>};

    for (<amount, locs> <- cloneList) {
        barChartData += {<"0<amount>", size(locs)>};
    }

    // Original value removed
    barChartData = barChartData - {<"",0>};

    return barChartData;
}

private int getNumberOfChildNodes(node n, int weight) {
    int count = 0;
    visit(n) {
        case node _n: {
            count += 1;
            if(count > weight) {
                // Stop visit when weight has been reached
                return count;
            }
        }
    }
    return count;
}

// Similarity treshold from Baxter's paper
bool isSimilar(set[node] a, set[node] b) {
    return (2 * size(a & b) / toReal(2 * size(a & b) + size(a - b) + size(b - a))) > 0.9;
}

// Return a map of type-3 clones
public map[value, set[loc]] getType3Clones(list[Declaration] asts, int weight) {
    map[int, map[node, loc]] blockAST = ();
    list[tuple[value, loc]] subsumptions = [];

    // Add all subtrees to a HashMap starting from a certain weight
    top-down visit(asts) {
        case _Node: \block(impl): {
            blockSize = size(impl);
            if (_Node.src? && getNumberOfChildNodes(_Node, weight) >= weight) {
                if (blockSize notin blockAST){ blockAST[blockSize] = (); }

                blockAST[blockSize][_Node] = _Node.src;
            }
        }
    }


    map[node, set[loc]] clones = ();

    // Compare blocks with each block in neighbouring buckets.
    for (blockSize <- blockAST) {

        // Arbitary difference between block sizes in number of statements.
        int diff = toInt(blockSize * 0.4);

        for (a <- blockAST[blockSize]) {
            for (offset <- [-diff .. diff + 1], blockSize + offset in blockAST) {
                for (b <- blockAST[blockSize + offset]) {
                    if (a != b) {
                        unset_a = unsetRec(a);
                        unset_b = unsetRec(b);

                        // When similar try and aggregate on node a, such that collisions create a larger clone class.
                        if (isSimilar(toSet(unset_a.statements), toSet(unset_b.statements))) {
                            if (unset_a in clones)
                                clones[unset_a] += {a.src, b.src};
                            elseif (unset_b in clones)
                                clones[unset_b] += {a.src, b.src};
                            else
                                clones[unset_a] = {a.src, b.src};
                        }
                    }
                }
            }
        }
    }

    for ( key <- clones) {
        if (size(clones[key]) > 1) {
            for (source <- clones[key]) {
                // loop again over the same map
                for ( keyTwo <- clones) {
                    if (size(clones[keyTwo]) > 1) {
                        for (src <- clones[keyTwo]) {
                            if(isStrictlyContainedIn(source, src)) {
                                subsumptions += <key, source>;
                                break;
                            }
                        }
                    }
                }
            }
        }
    }

    // Remove all subsumptions from the tree
    for (tuple[node n, loc src] sub <- subsumptions) {
        clones[unsetRec(sub.n)] -= {sub.src};
    }


    return clones;
}
