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


bool hasClones(Statement forLoop, list[Declaration] asts, value loopSource){
    println("START: <loopSource>");
    visit(asts){
         case loop: \for(_,_,_,_): forLoop := loop ? println("\tyeah <loop.src>") : println("\tnop <loop.src>");
    }

    return false;
}

void analyseProject(loc project, int cloneWeight) {
    <model, asts> = getASTs(project);
    map[value, rel[node,loc]] type1CloneMap = getType1Clones(asts, cloneWeight);
    printType1Clones(type1CloneMap);
}


void main() {
    int cloneWeight = 40;
    analyseProject(|project://sampleJava|, cloneWeight);
    // analyseProject(|project://smallsql0.21_src|, cloneWeight);
    // analyseProject(|project://hsqldb-2.3.1|, cloneWeight);
}
