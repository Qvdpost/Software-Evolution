module BasicEval

import IO;
import Set;
import List;
import String;

import lang::java::m3::Core;
import lang::java::m3::AST;

void eval(loc file) {
  if (\compilationUnit(_,[\class(_,_,_,[\method(_,_,_,_,\block(stmts))])]) := createAstFromFile(file, true)) {
     for (stmt <- stmts) {
       if (\expressionStatement(\methodCall(_,_,_,[expr])) := stmt)
         println(eval(expr));
     }
  }
}

//value eval((Expression) `<Expression lhs> + <Expression rhs>`) = eval(lhs) + eval(rhs);
//value eval((Expression) `<Expression lhs> * <Expression rhs>`) = eval(lhs) * eval(rhs);

value eval(\infix(lhs,"*",rhs)) {
  if (num l_val := eval(lhs), num r_val := eval(rhs)) 
    return l_val * r_val;
  else 
    println("ERR: (*) expects two numerical values");
  return null;
}
value eval(\infix(lhs,"+",rhs)) {
  value l_val = eval(lhs), r_val = eval(rhs);
  if (num l_val := l_val, num r_val := r_val)
    return l_val + r_val;
  else if (str l_val := l_val, str r_val := r_val)
    return l_val + r_val;
  else 
    println("ERR: (+) expects numerical values or strings");
  return null;
}
value eval(\number(q)) = toInt(q);
value eval(\stringLiteral(s)) = s[1..-1];