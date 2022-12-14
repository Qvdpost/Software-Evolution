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
    <totalCodeLines, _> = mainLoC(project);

    type1Map = getType1Clones(asts, cloneWeight);
    type1CloneList = getSlocs(type1Map);
    int nrOfClones = getNumberOfClones(type1Map);
    println("Clones: <nrOfClones>");

    <barChartData, nrOfClonedLines> = convertToCharData(type1CloneList);
    println(totalCodeLines);
    println("nrOfClonedLines: <nrOfClonedLines>\nPercentage: <getPercentage(nrOfClonedLines,totalCodeLines)>%");
    // dumpToJson("Type1Clones.json",type1CloneList);
    // showInteractiveContent(barChart(barChartData,title="Type 1 Clones", colorMode=\dataset()));

    println("-------");
    iprintln(type1CloneList);
    println("-------");



    // asts = rewriteAST(asts);
    // <type2CloneList, nrOfType2Clones> = getType1Clones(asts, cloneWeight);
    // <barChartDataType2, nrOfClonedLinesType2> = convertToCharData(type2CloneList);
    // println(totalCodeLines);
    // println("nrOfClonedLines: <nrOfClonedLinesType2>\nPercentage: <getPercentage(nrOfClonedLinesType2,totalCodeLines)>%");
    // // dumpToJson("Type2Clones.json",type2CloneList);
    // iprintln(type2CloneList);

    // <type3CloneList, nrOfType3Clones> = getType3Clones(asts, cloneWeight);
    // iprintln(type3CloneList);

    // showInteractiveContent(barChart(barChartDataType2,title="Type 2 Clones", colorMode=\dataset()));

    // printCloneMap(type2CloneMap);
    // println("Size: <size(type2CloneMap)>");
    // dumpToJson("out.json", asts);

}


void main() {
    int cloneWeight = 20;
    datetime startTime = now();
    // analyseProject(|project://tinyJava|, cloneWeight);
    analyseProject(|project://sampleJava|, cloneWeight);
    // analyseProject(|project://smallsql0.21_src|, cloneWeight);
    // analyseProject(|project://hsqldb-2.3.1|, cloneWeight);
    println(createDuration(startTime, now()));
}
