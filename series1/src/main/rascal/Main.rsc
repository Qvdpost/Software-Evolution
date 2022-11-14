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

void main() {
    // loc project = |project://smallsql0.21_src|;
    loc project = |project://sampleJava|;
    // loc project = |project://series1|;
    <model, asts> = getASTs(project);

    <lineCount, rating> = mainLoC(project);
    <ratingsMap, unitSizeRiskProfile> = getUnitVolumeRiskProfile(model, project);
    <complexityMap, complexityRiskProfile> = complexityRank(model, lineCount, project);
    int nrOfAsserts = countAsserts(asts);

    println("\n");
    println("Ratings of project: <project>");
    println("------------------------------------");

    println(left("| Volume", 22) + left("| <rating>",5) + "| LoC: <lineCount>");
    println(left("| Unit Size",22) + left("| <unitSizeRiskProfile>",5) + "| <ratingsMap>");
    println(left("| Complexity per unit", 22) + left("| <complexityRiskProfile>",5) + "| <complexityMap>");
    println(left("| Unit testing", 22) + left("| <nrOfAsserts>",5) + "|");
}
