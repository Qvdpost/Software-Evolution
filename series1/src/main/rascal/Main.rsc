module Main

import IO;

import metrics::volume::LoC;

void main() {
    loc project = |project://smallsql0.21_src|;
    // loc project = |project://sampleJava|;

    int lineCount = mainLoC(project);

    println("Lines of code in <project>: <lineCount>.");

}