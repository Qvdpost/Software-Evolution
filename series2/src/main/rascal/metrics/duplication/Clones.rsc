module metrics::duplication::Clones

import metrics::volume::LoC;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lib::Common;
import lib::Debug;
import lib::AstLib;
import metrics::volume::LoC;

import IO;
import List;
import Set;
import Map;
import Node;
import Location;

map[value, rel[node,loc]] initOrIncrMap(map[value, rel[node,loc]] mapping, node _Node) {
    node unsetNode = unsetRec(_Node);

    if (unsetNode in mapping) mapping[unsetNode] += {<_Node, _Node.src>};

	else { mapping[unsetNode] = {<_Node, _Node.src>};}

	return mapping;
}

public lrel[int,list[value]] getSlocs(map[value, rel[node,loc]] cloneMap){
    map[int, list[value]] cleanMap = ();
    for (key <- cloneMap){
        if (size(cloneMap[key]) > 1) {
            for (<_, src> <- cloneMap[key]) {
                cleanMap[countLoC(src)] ? [] += [src];
            }
        }
    }
    sortedList = sort(toList(cleanMap));

    return sortedList;
}

public int getNumberOfClones(map[value, rel[node,loc]] cloneMap){
    int counter = 0;
    for ( key <- cloneMap) {
        if (size(cloneMap[key]) > 1) {
            for (_ <- cloneMap[key]) {
                counter += 1;
            }
        }
    }
    return counter;
}

public void printCloneMap(lrel[int,list[value]] cloneMap){
    for ( <amountCloneLines, locs> <- cloneMap) {
        println("<amountCloneLines>");
        for (l<- locs) {
            println(l);
        }
    }
}

public tuple[lrel[int,list[value]], int] getType1Clones(list[Declaration] asts, int weight) {
    map[value, rel[node,loc]] nodeAst = ();
    list[rel[node,loc]] subsumptions = [];

    // Add all subtrees to a HashMap starting from a certain weight
    top-down visit(asts) {
        case node _Node : {
            if (_Node.src? && getNumberOfChildNodes(_Node, weight) > weight){
                nodeAst = initOrIncrMap(nodeAst, _Node);
            }
        }
    }

    for ( key <- nodeAst) {
        if (size(nodeAst[key]) > 1) {
            for (<nod,source> <- nodeAst[key]) {
                // loop again over the same map
                for ( keyTwo <- nodeAst) {
                    if (size(nodeAst[keyTwo]) > 1) {
                        for (<n,src> <- nodeAst[keyTwo]) {
                            if(isStrictlyContainedIn(source, src)) {
                                subsumptions += {<nod,source>};
                                break;
                            }
                        }
                    }
                }
            }
        }
    }

    // Remove all subsumptions from the tree
    for (subsumption <- subsumptions) {
        <n, src> = getFirstFrom(subsumption);
        tmpMap = nodeAst[unsetRec(n)];
        nodeAst[unsetRec(n)] = tmpMap - <n, src>;
    }

    int nrOfClones = getNumberOfClones(nodeAst);

    return <getSlocs(nodeAst), nrOfClones>;
}

public tuple[rel[str, int], int] convertToCharData(lrel[int,list[value]] cloneList){
    barChartData = {<"",0>};
    int nrOfClonedLines = 0;

    for (<amount, locs> <- cloneList) {
        barChartData += {<"0<amount>", size(locs)>};
        nrOfClonedLines = amount * size(locs);
    }

    barChartData = barChartData - {<"",0>};

    return <barChartData,nrOfClonedLines>;
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
