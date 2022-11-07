module metrics::volume::LoC

import util::FileSystem;

import IO;
import List;
import Set;

import island::Load;
import island::AST;
import island::Parse;
import island::Syntax;

int countLoC(Prog asts) {
    int count = 0;

    visit(asts) {
        case \nonComment(_): {count += 1;}
    }

    return count;
}

int mainLoC(loc project) {
    list[island::AST::Prog] asts = [ island::Load::load(path) | path <- {p | sp <- getPaths(project, "java"), p <- find(sp, "java"), isFile(p)} ];

    return sum([countLoC(ast) | ast <- asts]);
}