module lib::Common

import lang::java::m3::Core;
import lang::java::m3::AST;
import util::Math;


public tuple[M3,list[Declaration]] getASTs(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[Declaration] asts = [createAstFromFile(f, true)
        | f <- files(model.containment), isCompilationUnit(f)];
    return <model,asts>;
}

public tuple[M3,list[Declaration]] getFilesetASTs(loc projectLocation, set[loc] fileSet) {
    M3 model = createM3FromFiles(projectLocation, fileSet);

    list[Declaration] asts = [createAstFromFile(f, true)
        | f <- files(model.containment), isCompilationUnit(f)];

    return <model, asts>;
}

public real getPercentage(int x, int y){
    return precision((toReal(x) / toReal(y) * 100), 4);
}

public real getPercentage(real x, real y){
    return precision((x / y * 100), 4);
}

public real getPercentage(int x, real y){
    return precision((toReal(x) / y * 100), 4);
}

public real getPercentage(real x, int y){
    return precision((x / toReal(y) * 100), 4);
}
