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

    asts = rewriteAST(asts);
    map[value, rel[node,loc]] type1CloneMap = getType1Clones(asts, cloneWeight);

    dumpToJson("out.json", asts);
    printType1Clones(type1CloneMap);
    println("Size: <size(type1CloneMap)>");
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
