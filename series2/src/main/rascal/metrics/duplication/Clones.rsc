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


map[value, rel[node,loc]] initOrIncrMap(map[value, rel[node,loc]] mapping, node _Node) {
    node unsetNode = unsetRec(_Node);
	if (unsetNode in mapping) mapping[unsetNode] += {<_Node, _Node.src>};

	else { mapping[unsetNode] = {<_Node, _Node.src>};}

	return mapping;
}

public void printType1Clones( map[value, rel[node,loc]] cloneMap){
    for ( key <- cloneMap) {
        if (size(cloneMap[key]) > 1) {
            for (<_,source> <- cloneMap[key]) {
                println(source);
            }
        }
    }
}

public map[value, rel[node,loc]] getType1Clones(list[Declaration] asts) {
    list[Declaration] methodAst = getMethodAst(asts);
    map[value, rel[node,loc]] nodeAst = ();

	visit(methodAst) {
        case node _Node : {
            if(_Node.src? && size(getChildren(_Node)) > 4) {
                nodeAst = initOrIncrMap(nodeAst, _Node);
            }
        }
    }

    return nodeAst;
}
