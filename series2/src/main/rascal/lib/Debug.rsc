module lib::Debug

import IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::json::IO;
import lib::Common;
import lib::AstLib;

public void dumpMethodAst(loc target, list[Declaration] fullAst) {
    initFile(target);
    list[Declaration] methodAst = getMethodAst(fullAst);
    iprintToFile(target, methodAst);
}

public void dumpGeneric(loc target, value values) {
    initFile(target);
    iprintToFile(target, values);
}

public void dumpToJson(loc target, value values) {
    initFile(target);
    writeJSON(target, values);
}
