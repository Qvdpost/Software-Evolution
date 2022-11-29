module Main

import IO;
import String;
import List;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lib::Common;
import lib::AstLib;
import lib::Debug;
import Node;

import metrics::duplication::Preprocessing;

bool hasClones(Statement forLoop, list[Declaration] asts, value loopSource){
    println("START: <loopSource>");
    visit(asts){
         case loop: \for(_,_,_,_): forLoop := loop ? println("\tyeah <loop.src>") : println("\tnop <loop.src>");
    }

    return false;
}

void analyseProject(loc project) {
    <model, asts> = getASTs(project);
    rewriteAST(asts);
    dumpGeneric(|file:///home/quinten/Documents/SoftwareEngineering/software_evolution/Software-Evolution/series2/src/main/rascal/out.txt|, asts);
    // loc x = |file:///Users/jorrit/Documents/Software-Evolution/series2/src/main/rascal/out.json|;
    // writeFile(x, asts);

//   \for(list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body)

    // visit(asts){
    //     case loop: \for(_,_,_): println(loop);
    //     // case loop: \for(list[Expression] \declarationExpression(X),_,_,_): println(X);
    //     case loop: \for(list[Expression] initializer,_,_,_): hasClones(loop, asts, loop.src);
    //     // case loop: \for(_,_,_,_): println(getName(loop));


    // }

}

void eval(loc file) {
//   Declaration ast = createAstFromFile(file, true);
//   loc x = |file:///Users/jorrit/Documents/Software-Evolution/series2/src/main/rascal/out.json|;
//   writeFile(x, ast);
//   println(\compilationUnit(_,_,[\class(_,_,_,classMethods)]) := ast);
// [\method(_,_,_,_,\block(stmts))]
  if (\compilationUnit(_,_,[\class(_,_,_,classMethods)]) := createAstFromFile(file, true)) {


    //  | \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl)
    //  | \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions)
     for (\method(ret,name,_,exceptions,\block(stmts)) <- classMethods) {
        // println(name);
        // visit(stmts) {
        //     case loop: \for(_,_,_,_): println(getName(loop));
        // }
        // println(name);
        for (stmt <- stmts){


        if (\expressionStatement(\methodCall(_,_,_,[expr])) := stmt)
            // println(eval(expr));
            println(expr);
            println("xxxxxxx");
        }
     }
  }
}


void main() {
    analyseProject(|project://sampleJava|);
    // eval(|file:///Users/jorrit/Documents/Software-Evolution/java_projects/sampleJava/src/main/java/Calculate.java|);
    // analyseProject(|project://smallsql0.21_src|);
    // analyseProject(|project://hsqldb-2.3.1|);
}
