module Main

import IO;

import metrics::volume::LoC;
import metrics::volume::UnitSize;
import metrics::complexity::Cyclomatic;

void main() {
    // loc project = |project://smallsql0.21_src|;
    loc project = |project://sampleJava|;
    // loc project = |project://series1|;

    int lineCount = mainLoC(project);
    map[loc, int] methodMap = countMethodLoC(project);


    for (key <- [f | f <- methodMap]) {
        println("LoC: <methodMap[key]> in method: <key>");
    }
    println("Lines of code in <project>: <lineCount>.");

    println("The unit complexity rating for <project> is: \'<complexityRank(lineCount, project)>\'");

}