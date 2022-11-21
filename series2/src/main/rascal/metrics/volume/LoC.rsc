module metrics::volume::LoC

import util::FileSystem;

import IO;
import List;
import Set;

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

list[Decls] getLoC(island::AST::Prog prog) {
    list[Decls] decls = [];
    visit (prog) {
        case decl:nonComment(_): decls += decl;
    }

    return decls;
}

// According to http://www.cs.bsu.edu/homepages/dmz/cs697/langtbl.htm
// A Java developer produces about 15 'Function Points' per month
// and 53 statements per FP.
// That equates to: 15 * 12 * 53 = 9540 LoC per person per year
// So LoC / 9540 equates to nr of dev years which can be scored by
// the current maintanability model.
//
// This is slightly different from the table in the scientific paper.
// There a MY calculatation is done which equates to somewhere between
// 8000 - 8250 LoC per year.
private int getFunctionPointsLoCperYear(){
    int functionPointsJava = (15 * 12);
    int statementsPerFp = 53;

    return functionPointsJava * statementsPerFp;
}

private str calculateVolumeRating(int linesOfCode) {
    int projectScore = linesOfCode / getFunctionPointsLoCperYear();

    return  projectScore <= 8   ? "++" :
            projectScore <= 30  ? "+" :
            projectScore <= 80  ? "o" :
            projectScore <= 160 ? "-" :
                                  "--";
}

public tuple[int, str] mainLoC(loc project) {
    list[island::AST::Prog] asts = getIslandASTsFromProject(project);

    int linesOfCode = sum([countLoC(ast) | ast <- asts]);
    str rating = calculateVolumeRating(linesOfCode);

    return <linesOfCode, rating>;
}
