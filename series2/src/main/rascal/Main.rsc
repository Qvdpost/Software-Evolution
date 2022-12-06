module Main

import IO;
import String;
import List;
import Node;
import DateTime;
import Map;
import Set;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lib::Common;
import lib::AstLib;
import lib::Debug;
import metrics::duplication::Clones;
import metrics::duplication::Preprocessing;
import metrics::volume::LoC;
import lang::json::IO;
import vis::Charts;
import util::IDEServices;

bool hasClones(Statement forLoop, list[Declaration] asts, value loopSource){
    println("START: <loopSource>");
    visit(asts){
         case loop: \for(_,_,_,_): forLoop := loop ? println("\tyeah <loop.src>") : println("\tnop <loop.src>");
    }

    return false;
}

void analyseProject(loc project, int cloneWeight) {
    <model, asts> = getASTs(project);

    <type1CloneList, nrOfClones> = getType1Clones(asts, cloneWeight);
    <barChartData, nrOfClonedLines> = convertToCharData(type1CloneList);
    <totalCodeLines, _> = mainLoC(project);
    println(totalCodeLines);
    println("nrOfClonedLines: <nrOfClonedLines>\nPercentage: <getPercentage(nrOfClonedLines,totalCodeLines)>%");
    dumpToJson("Type1Clones.json",type1CloneList);


    showInteractiveContent(barChart(barChartData,title="Type 1 Clones", colorMode=\dataset()));

    asts = rewriteAST(asts);
    map[value, rel[node,loc]] type2CloneMap = getType1Clones(asts, cloneWeight);
    printCloneMap(type2CloneMap);

}


void main() {
    int cloneWeight = 40;
    datetime startTime = now();
    analyseProject(|project://tinyJava|, cloneWeight);
    // analyseProject(|project://sampleJava|, cloneWeight);
    // analyseProject(|project://smallsql0.21_src|, cloneWeight);
    // analyseProject(|project://hsqldb-2.3.1|, cloneWeight);
    println(createDuration(startTime, now()));
}
