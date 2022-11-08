module metrics::volume::LoC

import util::FileSystem;

import IO;
import List;
import Set;

import island::Load;
import island::AST;
import island::Syntax;

public str lang = "java";

int countLoC(Prog ast) {
    int count = 0;

    visit(ast) {
        case \nonComment(_): {count += 1;}
    }

    return count;
}

list[island::AST::Prog] getIslandASTsFromProject(loc project) {
    return getIslandASTsFromFiles([path | path <- {p | sp <- getPaths(project, lang), p <- find(sp, lang), isFile(p)}]);
}

list[island::AST::Prog] getIslandASTsFromFiles(list[loc] files) {
    return [getIslandASTsFromFile(path) | path <- files];
}

island::AST::Prog getIslandASTsFromFile(loc file) {
    return island::Load::load(file);
}

list[Decls] getLoC(island::AST::Prog prog) {
    list[Decls] decls = [];
    visit (prog) {
        case decl:nonComment(_): decls += decl;
    }

    return decls;
}

int mainLoC(loc project) {
    list[island::AST::Prog] asts = getIslandASTsFromProject(project);

    return sum([countLoC(ast) | ast <- asts]);
}