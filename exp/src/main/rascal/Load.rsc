module Load

import Syntax;
import AST;
import Parse;

import ParseTree;

AST::Prog implode(Syntax::Prog p) = implode(#AST::Prog, p);

AST::Prog load(loc l) = implode(parse(l));
AST::Prog load(str s) = implode(parse(s));
