module Load

import Syntax;
import Parse;
import AST;

import ParseTree;

AST::Prog implode(Syntax::Prog p) = implode(#AST::Prog, p);

AST::Prog load(loc l) = implode(parseExp(l));
