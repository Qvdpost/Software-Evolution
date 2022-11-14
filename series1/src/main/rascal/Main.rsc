module Main

import IO;
import String;
import metrics::volume::LoC;
import metrics::volume::UnitSize;
import metrics::complexity::Cyclomatic;

void main() {
    // loc project = |project://smallsql0.21_src|;
    loc project = |project://sampleJava|;
    // loc project = |project://series1|;

    <lineCount, rating> = mainLoC(project);
    <ratingsMap, unitSizeRiskProfile> = getUnitVolumeRiskProfile(project);
    str complexityRiskProfile = complexityRank(lineCount, project);

    println("\n");
    println("Ratings of project: <project>");
    println("------------------------------------");

    println(left("| Volume", 22) + left("| <rating>",5) + "| LoC: <lineCount>");
    println(left("| Unit Size",22) + left("| <unitSizeRiskProfile>",5) + "| <ratingsMap>");
    println(left("| Complexity per unit", 22) + left("| <complexityRiskProfile>",5) + "|");
}
