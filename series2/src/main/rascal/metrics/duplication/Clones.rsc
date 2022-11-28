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

void main() {
    loc project = |project://sampleJava|;
    loc dumpTarget = |file:///Users/jorrit/Documents/master-software-engineering/Software-Evolution/series2/src/main/rascal/out.txt|;
    loc dumpTarget2 = |file:///Users/jorrit/Documents/master-software-engineering/Software-Evolution/series2/src/main/rascal/out2.txt|;

    <model, asts> = getASTs(project);
    list[Declaration] methodAst = getMethodAst(asts);

    map[value, rel[node,loc]] nodeAst = ();
	visit(methodAst) {
        case node _Node : {
            if(_Node.src? && size(getChildren(_Node)) > 3) {
                nodeAst = initOrIncrMap(nodeAst, _Node);
            }
        }
    }

    // dumpGeneric(dumpTarget2, nodeAst);
    for ( key <- nodeAst) {
        if (size(nodeAst[key]) > 1) {
            for (<_,source> <- nodeAst[key]) {
                println(source);
            }
        }

    }
}
