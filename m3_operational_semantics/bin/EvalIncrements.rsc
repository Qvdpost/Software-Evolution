module EvalIncrements

import IO;
import Set;
import List;
import String;

import lang::java::m3::Core;
import lang::java::m3::AST;

alias sto = map[str,value];


void eval(loc file) {
  if (\compilationUnit(_,[\class(_,_,_,[\method(_,_,_,_,\block(stmts))])]) := createAstFromFile(file, true)) {
     map[str,value] store = ();
     for (stmt <- stmts) {
       if (\expressionStatement(\methodCall(_,_,_,[expr])) := stmt) {
         <v, store> = eval(expr,store);
         println(v);
       }
       if (\declarationStatement(\variables(_,[\variable(name,_,init)])) := stmt) {
         <v, store> = eval(init, store);
         store = store + (name : v);
       }
     }
  }
}

//value eval((Expression) `<Expression lhs> + <Expression rhs>`) = eval(lhs) + eval(rhs);
//value eval((Expression) `<Expression lhs> * <Expression rhs>`) = eval(lhs) * eval(rhs);

tuple[value,sto] eval(\infix(lhs,"*",rhs), store1) {
  <l_val, store2> = eval(lhs, store1);
  <r_val, store3> = eval(rhs, store2);
  if (num l_val := l_val, num r_val := r_val) 
    return <l_val * r_val, store3>;
  else 
    println("ERR: (*) expects two numerical values");
  return <null,store1>;
}
tuple[value,sto] eval(\infix(lhs,"+",rhs), store1) {
  <l_val,store2> = eval(lhs, store1);
  <r_val,store3> = eval(rhs, store2);
  if (num l_val := l_val, num r_val := r_val)
    return <l_val + r_val,store3>;
  else if (str l_val := l_val, str r_val := r_val)
    return <l_val + r_val,store3>;
  else if (int l_val := l_val, str r_val := r_val)
    return <"<l_val>" + r_val,store3>;
  else if (str l_val := l_val, int r_val := r_val)
    return <l_val + "<r_val>",store3>;
  else 
    println("ERR: (+) expects numerical values or strings");
  return <null,store1>;
}
tuple[value,sto] eval(\prefix("++", \simpleName(str s)), sto store) {
  if (s in store, num i := store[s]) {
    return <i+1,store + (s : i + 1)>;
  }
} 
tuple[value,sto] eval(\number(q), store) = <toInt(q), store>;
tuple[value,sto] eval(\stringLiteral(s), store) = <s[1..-1], store>;
tuple[value,sto] eval(\simpleName(str s), map[str,value] store) = <store[s],store>; 
tuple[value,sto] eval(\bracket(expr), store) = eval(expr,store);
default tuple[value,sto] eval(expr,store) {
  println("ERR: missing definition for eval\n    <expr>");
  return <null, store>;
} 

