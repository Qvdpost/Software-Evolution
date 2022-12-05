module Main

import IO;
import String;
import List;
import Node;
import DateTime;
import Map;

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

void analyseProject(loc project, int cloneWeight) {
    <model, asts> = getASTs(project);

    map[value, rel[node,loc]] type1CloneMap = getType1Clones(asts, cloneWeight);

    printType1Clones(type1CloneMap);
    // TODO: fix size of cloneMap by filtering > 1
    println("Size: <size(type1CloneMap)>");

    asts = rewriteAST(asts);
    map[value, rel[node,loc]] type2CloneMap = getType1Clones(asts, cloneWeight);
    printType1Clones(type2CloneMap);
    println("Size: <size(type2CloneMap)>");

    dumpToJson("out.json", asts);

}


void main() {
    int cloneWeight = 40;
    datetime startTime = now();
    analyseProject(|project://tinyJava|, cloneWeight);
    // analyseProject(|project://smallsql0.21_src|, cloneWeight);
    //3739, 24927
    // analyseProject(|project://hsqldb-2.3.1|, cloneWeight);
    println(createDuration(startTime, now()));
}
