module lib::Debug

import IO;
import lang::json::IO;


// Create a file if it doesn't exist
public void initFile(loc target) {
    touch(target);
    writeFile(target, "");
}

// Write given values to a JSON file.
public void dumpToJson(str target, value values) {
    loc targetFile = |project://series2/src/main/rascal/output|;
    targetFile += target;
    initFile(targetFile);
    writeJSON(targetFile, values);
}

// Print all clone classes of a given clone map
public void printCloneMap(map[value, set[loc]] cloneMap){
    for ( key <- cloneMap) {
        for (l<- cloneMap[key]) {
            iprintln(l);
        }
        iprintln("----------");
    }
}
