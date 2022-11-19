module Main

import IO;
import String;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lib::Common;
import metrics::volume::LoC;
import metrics::volume::UnitSize;
import metrics::complexity::Cyclomatic;
import metrics::testing::Asserts;
import metrics::maintainability::Aggregations;
import metrics::duplication::Duplicates;

void analyseProject(loc project) {
    <model, asts> = getASTs(project);

    println("\n");
    println("Source Code Properties of: <project>");
    println("------------------------------------");

    // <lineCount, rating> = mainLoC(project);
    // println(left("| Volume", 22) + left("| <rating>",5) + "| LoC: <lineCount>");

    // <ratingsMap, unitSizeRiskProfile> = getUnitVolumeRiskProfile(asts);
    // println(left("| Unit Size",22) + left("| <unitSizeRiskProfile>",5) + "| <prettyPrintPercentageMap(ratingsMap)>");

    // <complexityMap, complexityRiskProfile> = complexityRank(asts, lineCount);
    // println(left("| Complexity per unit", 22) + left("| <complexityRiskProfile>",5) + "| <prettyPrintPercentageMap(complexityMap)>");

    // <duplication, relativeDuplication, duplicationProfile> = duplicationRank(project, lineCount);
    // println(left("| Duplication", 22) + left("| <duplicationProfile>",5) + "| Dups: <duplication>; <relativeDuplication>%");

    real methodsTestedPercentage = countMethodsInTests(project, model, asts);
    println(left("| Unit testing", 22) + left("| <methodsTestedPercentage>",5) + "|");


    // println("\n");
    // println("Maintainability  of: <project>");
    // println("------------------------------------");
    // println(left("| Analysability", 22) + left("| <aggregateAnalysability(rating, duplicationProfile, unitSizeRiskProfile, "o")>", 5));
    // println(left("| Changeability", 22) + left("| <aggregateChangeability(complexityRiskProfile, duplicationProfile)>", 5));
    // println(left("| Stability", 22) + left("| <aggregateStability("o")>", 5));
    // println(left("| Testability", 22) + left("| <aggregateTestability(complexityRiskProfile, unitSizeRiskProfile, "o")>", 5));
}

void main() {
    analyseProject(|project://sampleJava|);
    analyseProject(|project://smallsql0.21_src|);
    // analyseProject(|project://hsqldb-2.3.1|);
}
