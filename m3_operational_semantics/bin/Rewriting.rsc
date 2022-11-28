module Rewriting

import IO;
import Set;
import List;
import String;
import util::Maybe;

import lang::java::m3::Core;
import lang::java::m3::AST; 

void eval(loc file) {
  if (\compilationUnit(_,[\class(_,_,_,[\method(_,_,_,_,\block(stmts))])]) 
       := createAstFromFile(file, true)) {
    for (\expressionStatement(\methodCall(_,_,_,[expr])) <- rewrite(stmts)) {
      println(expr);
     }
   }
}

&T rewrite(&T term) = innermost visit(term) {
       case \bracket(X) => X
       case \infix(\booleanLiteral(true),"&&",X) => X
       case \infix(X:\booleanLiteral(false),"&&",_) => X
       case \infix(X,"&&",\booleanLiteral(true)) => X
       case \infix(_,"&&",X:\booleanLiteral(false)) => X
       case \infix(X:\booleanLiteral(true),"||",_) => X
       case \infix(_,"||",X:booleanLiteral(true)) => X
       case \infix(\booleanLiteral(false),"||",X) => X
       case \infix(X,"||",\booleanLiteral(false)) => X
       case \conditional(\booleanLiteral(true),X,_) => X
       case \conditional(\booleanLiteral(false),_,X) => X
      };
