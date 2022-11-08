module metrics::volume::UnitSize


import lang::java::m3::Core;
import lang::java::m3::AST;
// import island::Load;
import metrics::volume::LoC;
import IO;
import List;
import Set;
import String;


list[Declaration] getASTs(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[Declaration] asts = [createAstFromFile(f, true)
        | f <- files(model.containment), isCompilationUnit(f)];
    return asts;
}

public void getMethods(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);

    visit (methods(model)) {
        // case method: loc _ :  println(island::Load::load(readFile(method)));
        case method: loc _ :  println(countLoC(getIslandASTsFromFile(method)));

    }
}

void main(){
    loc project = |project://sampleJava|;
    getMethods(project);
}