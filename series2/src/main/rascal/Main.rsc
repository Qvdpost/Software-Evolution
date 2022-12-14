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
import lib::Debug;

import metrics::duplication::Clones;
import metrics::duplication::Preprocessing;
import metrics::volume::LoC;
import lang::json::IO;
import vis::Charts;
import util::IDEServices;
import output::Generate;

// Add each clone map to a single JSON file.
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

// Print clonemap statistics in a readable format
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

void analyseProject(loc project, int cloneWeight, bool printCloneMaps) {
     datetime startTime = now();
    <model, asts> = getASTs(project);
    totalCodeLines = mainLoC(project);

    // Initialize data for JSON output
    list[map[str,map[str,value]]] outputList = [];

    println("\n");
    println("Clone classes of: <project>");
    println("Project total lines of code: <totalCodeLines>");

    // Get map containing all  Type 1 clones
    map[value, set[loc]] type1Map = getCloneMap(asts, cloneWeight);

    genForceGraph(model, type1Map, "type1");

    // Rewrite to map to get output for graph data
    type1CloneList = getSlocs(type1Map);
    barChartData1 = convertToCharData(type1CloneList);

    // Add to output JSON file
    outputList += prettyPrintCloneMap("1", type1Map, totalCodeLines);

    // Rewrite AST for type 2 clones
    asts = rewriteAST(asts);

    type2Map = getCloneMap(asts, cloneWeight);
    type2CloneList = getSlocs(type2Map);
    barChartData2 = convertToCharData(type2CloneList);

    // Add to output JSON file
    outputList += prettyPrintCloneMap("2", type2Map, totalCodeLines);
    genForceGraph(model, type2Map, "type2");

    // Type 3
    type3Map = getType3Clones(asts, cloneWeight);
    type3CloneList = getSlocs(type3Map);
    barChartData3 = convertToCharData(type3CloneList);

    // Add to output JSON file
    outputList += prettyPrintCloneMap("3", type3Map, totalCodeLines);

    genForceGraph(model, type3Map, "type3");

    // Add project data and write all clones to a JSON file
    outputList = insertAt(outputList,0,(
        "ProjectData" : (
                "ProjectName" : "<project>",
                "TotalSloc" : totalCodeLines
            )
    ));

    // Write all clone data to a JSON file
    dumpToJson("out.json", outputList);

    if (printCloneMaps) {
        println("----------------------------------------\n");
        println("Type  1:");
        println("----------------------------------------");

        printCloneMap(type1Map);

        println("----------------------------------------\n");
        println("Type  2:");
        println("----------------------------------------");

        printCloneMap(type2Map);

        println("----------------------------------------\n");
        println("Type  3:");
        println("----------------------------------------");

        printCloneMap(type3Map);


        showInteractiveContent(barChart(barChartData1,title="Type 1 Clones", colorMode=\dataset()));
        showInteractiveContent(barChart(barChartData2,title="Type 2 Clones", colorMode=\dataset()));
        showInteractiveContent(barChart(barChartData3,title="Type 3 Clones", colorMode=\dataset()));
    }
}


void main() {
    int cloneWeight = 30;
    datetime startTime = now();
    // analyseProject(|project://sampleJava|, cloneWeight, false);
    analyseProject(|project://smallsql0.21_src|, cloneWeight, false);
    // analyseProject(|project://hsqldb-2.3.1|, cloneWeight, false);
    println(createDuration(startTime, now()));
}
