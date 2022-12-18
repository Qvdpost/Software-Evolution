module metrics::volume::LoC

import util::FileSystem;

import IO;
import List;

import island::Load;
import island::AST;
import island::Syntax;

public str lang = "java";

public int countLoC(Prog ast) {
    int count = 0;

    visit(ast) {
        case \nonComment(_): {count += 1;}
    }

    return count;
}

public int countLoC(loc file) {
    island::AST::Prog ast = getIslandASTsFromFile(file);
    return countLoC(ast);
}

public list[island::AST::Prog] getIslandASTsFromProject(loc project) {
    return getIslandASTsFromFiles({path | path <- {p | sp <- getPaths(project, lang), p <- find(sp, lang), isFile(p)}});
}

public list[island::AST::Prog] getIslandASTsFromFiles(set[loc] files) {
    return [getIslandASTsFromFile(path) | path <- files];
}

public island::AST::Prog getIslandASTsFromFile(loc file) {
    return island::Load::load(file);
}

public int mainLoC(loc project) {
    list[island::AST::Prog] asts = getIslandASTsFromProject(project);

    int linesOfCode = sum([countLoC(ast) | ast <- asts]);

    return linesOfCode;
}
