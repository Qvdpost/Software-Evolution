module metrics::duplication::Clones

import metrics::volume::LoC;

import lang::java::m3::Core;
import lang::java::m3::AST;
import lib::Common;
import lib::Debug;
import lib::AstLib;

import IO;
import List;
import Set;
import Map;
import Node;
import Location;

public bool checkForSubsumption(map[value, rel[node,loc]] cloneMap, _node){
    for ( key <- cloneMap) {
        if (size(cloneMap[key]) > 1) {
            for (<n,source> <- cloneMap[key]) {
                // If the current source is part of a large part. return true
                if(isStrictlyContainedIn(_node.src, source)) {
                    return true;
                }
            }
        }
    }
    return false;
}

map[value, rel[node,loc]] initOrIncrMap(map[value, rel[node,loc]] mapping, node _Node) {
    node unsetNode = unsetRec(_Node);

    if (unsetNode in mapping) mapping[unsetNode] += {<_Node, _Node.src>};

	else { mapping[unsetNode] = {<_Node, _Node.src>};}

	return mapping;
}

public void printType1Clones( map[value, rel[node,loc]] cloneMap){
    for ( key <- cloneMap) {
        if (size(cloneMap[key]) > 1) {
            for (<nod,source> <- cloneMap[key]) {
                println(source);
            }
        }
    }
}

public map[value, rel[node,loc]] getType1Clones(list[Declaration] asts, int weight) {
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
    return nodeAst;
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
