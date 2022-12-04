module Main

import IO;
import String;
import List;
import Node;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lib::Common;
import lib::AstLib;
import lib::Debug;
import metrics::duplication::Clones;


import metrics::duplication::Preprocessing;

bool hasClones(Statement forLoop, list[Declaration] asts, value loopSource){
    println("START: <loopSource>");
    visit(asts){
         case loop: \for(_,_,_,_): forLoop := loop ? println("\tyeah <loop.src>") : println("\tnop <loop.src>");
    }

    return false;
}

void analyseProject(loc project) {
    <model, asts> = getASTs(project);
    asts = rewriteAST(asts);

    dumpToJson(|file:///home/quinten/Documents/SoftwareEngineering/software_evolution/Software-Evolution/series2/src/main/rascal/out.json|, asts);

    // map[value, rel[node,loc]] type1CloneMap = getType1Clones(asts);
    // printType1Clones(type1CloneMap);

}



void main() {
    analyseProject(|project://sampleJava|);
    // analyseProject(|project://smallsql0.21_src|);
    // analyseProject(|project://hsqldb-2.3.1|);
}
