module SmallStep

import IO;
import String;
import util::Maybe;

import lang::java::m3::Core;
import lang::java::m3::AST;

alias source = tuple[node,store];
alias target = Maybe[tuple[value, store, output]];
alias store = map[str,value];
alias output = list[str];


void eval(loc file) {
  if (\compilationUnit(_,[\class(_,_,_,[\method(_,_,_,_,\block(stmt))])]) := createAstFromFile(file, true)) {
    // println("1");
     output out = [];
     store sto = ();
     solve(stmt) {
              // println(stmt);

        // println(step(<stmt, sto>));
       if(just(<stmt_, sto_, out_>) := step(<stmt, sto>)) {
       	   out = out + out_;
       	   stmt = stmt_;
       	   sto = sto_;
       }
     }
     for (str s <- out) {print(s);}
    //  for (str s <- sto) {print(s);}
  }
}



void main() {
    // eval(|file:///Users/jorrit/Documents/Software-Evolution/java_projects/sampleJava/src/main/java/Boolean.java|);
    eval(|file:///Users/jorrit/Documents/Software-Evolution/m3_operational_semantics/examples/while.java|);
}

target step(<[\empty(), *stmts], sto>) {
  return just(<stmts,sto,[]>);
}

target step(<[Statement stmt,*stmts], sto>) {
  if (just(<stmt_, sto_, out_>) := step(<stmt, sto>)) {
  	return just(<stmt_ + stmts, sto_, out_>);
  }
  fail;
}

target step(<\while(expr, body),sto>) = just(<\if(expr,\block([body,\while(expr,body)])), sto, []>);

target step(<\if(cond, then), sto>) {
  if (just(<cond_,sto_,out_>) := step(<cond, sto>)) {
  	return just(<\if(cond_,then),sto_,out_>);
  }
  fail;
}

target step(<\if(\booleanLiteral(true),then), sto>) = just(<then, sto, []>);
target step(<\if(\booleanLiteral(false),then), sto>) = just(<\empty(), sto, []>);

target step(<\block([]), sto>) = just(<\empty(), sto, []>);
target step(<\block(stmts), sto>) {
  if (just(<stmts_, sto_, out_>) := step(<stmts, sto>)) {
    return just(<\block(stmts_), sto_, out_>);
  }
  fail;
}

// any method call with one actual parameter is interpreted as a print statement
target step(<\expressionStatement(\methodCall(a,b,c,[expr])), sto>) {
  // println(expr);
  // println("2");
  if (just(<expr_,sto_,out_>) := step(<expr, sto>)) {
    return just(<\expressionStatement(\methodCall(a,b,c,[expr_])), sto_, out_>);
  }
  fail;
}
target step(<\expressionStatement(\methodCall(a,b,c,[\number(q)])), sto>) {
  // println("3");
  return just(<\empty(), sto, [q, "\n"]>);
}


target step(<\expressionStatement(\assignment(\simpleName(str lhs),"=",\number(q))), sto>) {
  // println("4");
	return just(<\empty(), sto + (lhs : toInt(q)), []>);
}
target step(<\expressionStatement(\assignment(\simpleName(str lhs),"=",expr)), sto>) {
  // println("5");
	if (just(<expr_,sto_,out_>) := step(<expr, sto>)) {
	  return just(<\expressionStatement(\assignment(\simpleName(lhs),"=",expr_)), sto_, out_>);
	}
	fail;
}
target step(<\simpleName(str s), map[str,value] sto>) = just(<\number("<sto[s]>"),sto,[]>);
target step(<\declarationStatement(_), sto>) = just(<\empty(), sto, []>);


target step(<\infix(\number(p),"*",\number(q)), sto>) {
  return just(<\number("<toInt(p) * toInt(q)>"), sto, []>);
}

target step(<\infix(\number(p),"+",\number(q)), sto>) {
  return just(<\number("<toInt(p) + toInt(q)>"), sto, []>);
}

target step(<\infix(\number(p),"\<=",\number(q)), sto>) {
  return just(<\booleanLiteral(toInt(p) <= toInt(q)), sto, []>);
}

target step(<\infix(\stringLiteral(p),"+",\stringLiteral(q)), sto>) {
  return just(<\stringLiteral("<p><q>"), sto, []>);
}

target step(<\infix(p,op,q), sto>) {
  if (just(<p_,sto_,out_>) := step(<p,sto>)) {
    return just(<\infix(p_,op,q),sto_,out_>);
  }
  fail;
}

target step(<\infix(p,op,q), sto>) {
  println("<p>");
  println("=======");
  println("<op>");
  println("=======");
  println("<q>");
  if (just(<q_,sto_,out_>) := step(<q,sto>)) {
    return just(<\infix(p,op,q_),sto_,out_>);
  }
  fail;
}

target step(<\expressionStatement(\methodCall(a,b,c,[\stringLiteral(s)])), sto>) {
  return just(<\empty(), sto, [s]>);
}

default target step(<_,sto>) {
  println("defaultcase");
  return nothing();
}