module metrics::volume::UnitSize


import lang::java::m3::Core;
import lang::java::m3::AST;
import metrics::volume::LoC;

public set[loc] getMethods(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    return methods(model);
}

public map[loc, int] countMethodLoC(loc projectLocation){
    set[loc] methods = getMethods(projectLocation);
    map[loc, int] methodSizes = ();

    visit (methods) {
        case currentMethod: loc _ :  methodSizes[currentMethod] = countLoC(getIslandASTsFromFile(currentMethod));
    }

    return methodSizes;
}
