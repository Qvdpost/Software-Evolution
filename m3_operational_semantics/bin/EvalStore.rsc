module EvalStore

import IO;
import Set;
import List;
import String;

import lang::java::m3::Core;
import lang::java::m3::AST;

void eval(loc file) {
  if (\compilationUnit(_,[\class(_,_,_,[\method(_,_,_,_,\block(stmts))])]) := createAstFromFile(file, true)) {
     map[str,value] store = ();
     for (stmt <- stmts) {
       if (\expressionStatement(\methodCall(_,_,_,[expr])) := stmt)
         println(eval(expr,store));
       if (\declarationStatement(\variables(_,[\variable(name,_,init)])) := stmt) 
         store = store + (name : eval(init, store));
     }
  }
}

//value eval((Expression) `<Expression lhs> + <Expression rhs>`) = eval(lhs) + eval(rhs);
//value eval((Expression) `<Expression lhs> * <Expression rhs>`) = eval(lhs) * eval(rhs);

value eval(\infix(lhs,"*",rhs), store) {
  if (num l_val := eval(lhs, store), num r_val := eval(rhs, store)) 
    return l_val * r_val;
  else 
    println("ERR: (*) expects two numerical values");
  return null;
}
value eval(\infix(lhs,"+",rhs), store) {
  value l_val = eval(lhs, store), r_val = eval(rhs, store);
  if (num l_val := l_val, num r_val := r_val)
    return l_val + r_val;
  else if (str l_val := l_val, str r_val := r_val)
    return l_val + r_val;
  else if (int l_val := l_val, str r_val := r_val)
    return "<l_val>" + r_val;
  else if (str l_val := l_val, int r_val := r_val)
    return l_val + "<r_val>";
  else 
    println("ERR: (+) expects numerical values or strings");
  return null;
}
value eval(\number(q), store) = toInt(q);
value eval(\stringLiteral(s), store) = s[1..-1];
value eval(\simpleName(str s), map[str,value] store) = store[s]; 

