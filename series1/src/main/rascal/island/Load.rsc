module island::Load

import island::Syntax;
import island::Parse;
import island::AST;

import ParseTree;

island::AST::Prog implode(island::Syntax::Prog p) = implode(#Prog, p);

island::AST::Prog load(loc l) = implode(parseExp(l));
