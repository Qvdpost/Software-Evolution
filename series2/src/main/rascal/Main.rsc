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
import output::Generate;


tuple[map[str, map[str,value]], int, int] addCloneClassToJson(str CloneClassType,  map[value, set[loc]] cloneMap) {
    // Initialize content of a type of clones
    map[str, map[str,value]] cloneClassContent = ( CloneClassType : (
            "TotalClonedSloc" : 0,
            "NrOfCloneClasses" : 0,
            "Clones" : []
        )
    );

    // Used for clonelations, nr. of classes, and total lines of cloned code
    cloneList = [];
    int counter = 0;
    int totalCloneLoc = 0;

    // From the given map of type 1/2/3 clones fill all data.
    for (key <- cloneMap) {
        int cloneSize = size(cloneMap[key]);

        if (cloneSize > 0) {
            counter += 1;
            slocs = countLoC(getFirstFrom(cloneMap[key]));
            cloneList += (
                "NrOfClones" : cloneSize,
                "LOC" : slocs,
                "Sources:" : toList(cloneMap[key])
            );
            totalCloneLoc += cloneSize * slocs;
        }
    }

    // Add all final figures
    cloneClassContent[CloneClassType]["NrOfCloneClasses"] = counter;
    cloneClassContent[CloneClassType]["TotalClonedSloc"] = totalCloneLoc;
    cloneClassContent[CloneClassType]["Clones"] = cloneList;

    // return JSON report of type 1/2/3 clone class
    return <cloneClassContent, totalCloneLoc, counter>;
}

map[str,map[str,value]] prettyPrintCloneMap(str cloneType, map[value, set[loc]] cloneMap, int totalCodeLines) {
    map[str,map[str,value]] jsonContents = ();

    println("Type <cloneType>:");
    println("----------------------------------------");
    <jsonContent, nrOfClonedLines, nrOfCloneClasses> = addCloneClassToJson("type<cloneType>Clones", cloneMap);

    // Print statistics
    int nrOfClones = getNumberOfClones(cloneMap);
    println(left("| Nr. of type <cloneType> clones:",30) + left("| <nrOfClones>",9) + "|");
    println(left("| Nr. of type <cloneType> clone classes:",30) + left("| <nrOfCloneClasses>",9) + "|");
    println(left("| Nr. of lines cloned:",30) + left("| <nrOfClonedLines>",9) + "|");
    println(left("| Percentage of lines cloned:",30) + left("| <getPercentage(nrOfClonedLines,totalCodeLines)>%",9) + "|");
    println("----------------------------------------\n");

    return jsonContent;
}

void analyseProject(loc project, int cloneWeight) {
    <model, asts> = getASTs(project);
    <totalCodeLines, _> = mainLoC(project);

    // Initialize data for JSON output
    list[map[str,map[str,value]]] outputList = [];

    println("\n");
    println("Clone classes of: <project>");
    println("Project total lines of code: <totalCodeLines>");

    // Get map containing all  Type 1 clones
    map[value, set[loc]] type1Map = getCloneMap(asts, cloneWeight);

    genForceGraph(model, type1Map);

    // Rewrite to map to get output for graph data
    type1CloneList = getSlocs(type1Map);
    barChartData = convertToCharData(type1CloneList);
    outputList += prettyPrintCloneMap("1", type1Map, totalCodeLines);

    // showInteractiveContent(barChart(barChartData,title="Type 1 Clones", colorMode=\dataset()));

    // Rewrite AST for type 2 clones
    // asts = rewriteAST(asts);

    // type2Map = getCloneMap(asts, cloneWeight);
    // type2CloneList = getSlocs(type1Map);
    // barChartData = convertToCharData(type2CloneList);

    // outputList += prettyPrintCloneMap("2", type2Map, totalCodeLines);

    // // Type 3
    // type3Map = getType3Clones(asts, cloneWeight);
    // outputList += prettyPrintCloneMap("3", type3Map, totalCodeLines);

    // // Add project data and write all clones to a JSON file
    // outputList = insertAt(outputList,0,(
    //     "ProjectData" : (
    //             "ProjectName" : "<project>",
    //             "TotalSloc" : totalCodeLines
    //         )
    // ));

    // dumpToJson("out.json", outputList);

    // println("----------------------------------------\n");
    // println("Type  1:");
    // println("----------------------------------------");

    // printCloneMap(type1Map);

    // println("----------------------------------------\n");
    // println("Type  2:");
    // println("----------------------------------------");

    // printCloneMap(type2Map);

    // println("----------------------------------------\n");
    // println("Type  3:");
    // println("----------------------------------------");

    // printCloneMap(type3Map);
}


void main() {
    int cloneWeight = 20;
    datetime startTime = now();
    // analyseProject(|project://tinyJava|, cloneWeight);
    // analyseProject(|project://sampleJava|, cloneWeight);
    analyseProject(|project://smallsql0.21_src|, cloneWeight);
    // analyseProject(|project://hsqldb-2.3.1|, cloneWeight);
    println(createDuration(startTime, now()));
}
