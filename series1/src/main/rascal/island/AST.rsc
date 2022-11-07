module island::AST

import Syntax;

import util::FileSystem;
import IO;

data Decls
    = cmnts(str i)
    | nonComment(str i)
    ;

data Prog
     = prog(list[Decls] decls)
     ;

// From lang::java::m3::AST
set[loc] getPaths(loc dir, str suffix) {
   bool containsFile(loc d) = isDirectory(d) ? (x <- d.ls && x.extension == suffix) : false;
   return find(dir, containsFile);
}