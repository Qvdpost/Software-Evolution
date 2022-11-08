module Main

import IO;

import metrics::volume::LoC;
import metrics::volume::UnitSize;

void main() {
    // loc project = |project://smallsql0.21_src|;
    loc project = |project://sampleJava|;

    int lineCount = mainLoC(project);
    map[loc, int] methodMap = countMethodLoC(getMethods(project));

    println(methodMap);
    println("Lines of code in <project>: <lineCount>.");

}