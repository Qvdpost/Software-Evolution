module metrics::volume::LoC

import util::FileSystem;

import IO;
import List;
import Set;

import island::Load;
import island::AST;
import island::Parse;
import island::Syntax;

int countLoC(Prog ast) {
    int count = 0;

    visit(ast) {
        case \nonComment(_): {count += 1;}
    }

    return count;
}

list[island::AST::Prog] getIslandASTsFromProject(loc project) {
    return getIslandASTsFromFiles([path | path <- {p | sp <- getPaths(project, "java"), p <- find(sp, "java"), isFile(p)}]);
}

list[island::AST::Prog] getIslandASTsFromFiles(list[loc] files) {
    return [getIslandASTsFromFile(path) | path <- files];
}

list[island::AST::Prog] getIslandASTsFromFile(loc file) {
    return island::Load::load(file);
}

int mainLoC(loc project) {
    list[island::AST::Prog] asts = getIslandASTsFromProject(project);

    return sum([countLoC(ast) | ast <- asts]);
}