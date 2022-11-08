module metrics::volume::LoC

import util::FileSystem;

import IO;
import List;
import Set;

import island::Load;
import island::AST;
import island::Syntax;

int countLoC(Prog asts) {
    int count = 0;

    visit(asts) {
        case \nonComment(_): {count += 1;}
    }

    return count;
}

list[island::AST::Prog] getIslandASTsFromProject(loc project) {
    return getIslandASTsFromFiles([path | path <- {p | sp <- getPaths(project, "java"), p <- find(sp, "java"), isFile(p)}]);
}

list[island::AST::Prog] getIslandASTsFromFiles(list[loc] files) {
    return [island::Load::load(path) | path <- files];
}

int mainLoC(loc project) {
    list[island::AST::Prog] asts = getIslandASTsFromProject(project);

    return sum([countLoC(ast) | ast <- asts]);
}