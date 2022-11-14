module lib::Common

import lang::java::m3::Core;
import lang::java::m3::AST;

public map[str, real] getRiskProfile() {
    return (
        "low": 0.0,
        "moderate": 0.0,
        "high": 0.0,
        "very_high": 0.0
    );
}

// Maps values of moderate, high and very high
public list[tuple[num, num, num, str]] getRankings() {
    return [
		<25, 0, 0, "++">,
		<30, 5, 0, "+">,
		<40, 10, 0, "o">,
		<50, 15, 5, "-">,
		<100, 100, 100, "--">
	];
}

public tuple[M3,list[Declaration]] getASTs(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[Declaration] asts = [createAstFromFile(f, true)
        | f <- files(model.containment), isCompilationUnit(f)];
    return <model,asts>;
}