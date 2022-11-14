module Main

import IO;

import metrics::volume::LoC;
import metrics::volume::UnitSize;
import metrics::complexity::Cyclomatic;

void main() {
    // loc project = |project://smallsql0.21_src|;
    loc project = |project://sampleJava|;
    // loc project = |project://series1|;

    <lineCount, rating> = mainLoC(project);
    println("UnitVolume rating is: <getUnitVolumeRiskProfile(project)>");

    println("Lines of code in <project>: <lineCount> with a volume rating of: \'<rating>\'.");

    println("The unit complexity rating for <project> is: \'<complexityRank(lineCount, project)>\'");

}