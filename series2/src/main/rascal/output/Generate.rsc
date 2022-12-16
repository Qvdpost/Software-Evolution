module output::Generate

import IO;
import lang::json::IO;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lib::Common;
import lib::AstLib;
import lib::Debug;

import Map;
import Node;
import Set;
import String;
import List;

map[str, value] genNode(str uid, int group) {
    return ("id": uid, "group": group);
}

map[str, value] genLink(str source, str target, int val) {
    return ("source": source, "target": target, "value": val);
}

list[map[str, value]] genLinks(str val, map[str, set[loc]] values) {
    return [genLink(src.path, val, size(values[val])) | src <- values[val]];
}

public map[str, list[map[str, value]]] genForceGraph(M3 model, map[value, set[loc]] values) {
    map[str, list[map[str, value]]] content = ();

    set[str] fileSet = { file.path | file <- files(model.containment)};

    map[value, set[loc]] reprs = ("&emsp;" + replaceAll(intercalate("\<br /\>", readFileLines(getOneFrom(values[val]))), "    ", "&emsp;"): values[val] | val <- domain(values), size(values[val]) > 0);

    content["nodes"] = [genNode(val, 1) | val <- domain(reprs)] + [genNode(file, 2) | file <- fileSet];

    content["links"] = concat([genLinks(val, reprs) | val <- domain(reprs)]);

    dumpToJson("output/force_graph.json", content);

    return content;
}