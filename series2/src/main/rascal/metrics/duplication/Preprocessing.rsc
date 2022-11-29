module metrics::duplication::Preprocessing

import lang::java::m3::Core;
import lang::java::m3::AST;
import lib::Common;
import lib::Debug;
import lib::AstLib;

import IO;

bool isVarType(Expression expr) {
	if (expr.decl.scheme == "java+variable")
		return true;

	if (expr.decl.scheme == "java+field")
		return true;

	if (\variable(_, _) := expr)
		return true;

	return false;
}

str typToString(TypeSymbol typ) {
	switch (typ) {
		case \class(_, _): return "class";
  		case \interface(_, _): return "interface";
  		case \enum(_): return "enum";
  		case \method(_, _, _, _): return "method";
  		case \constructor(_, _): return "cons";
  		case \typeParameter(_, _): "typeParam";
  		case \typeArgument(_): return "typeArg";
  		case \wildcard(_): return "wildcard";
  		case \capture(_, _): return "capture";
  		case \intersection(_): return "intersection";
  		case \union(_): return "union";
  		case \object(): return "object";
  		case \int(): return "int";
  		case \float(): return "float";
  		case \double(): return "double";
  		case \short(): return "short";
  		case \boolean(): return "bool";
  		case \char(): return "char";
  		case \byte(): return "byte";
  		case \long(): return "long";
  		case \void(): return "void";
  		case \null(): return "null";
  		case \array(_, _): return "array";
  		case \typeVariable(_): return "typeVar";
  		case \unresolved(): return "unresolved";
		default: return "unknown";
	}
	return "";
}

str replaceVarName(str word, Expression expr) {
	if (\qualifiedName(_, _) := expr)
		return "__qualifiedName__";
	switch (expr.typ) {
		case \int(): return "__" + typToString(expr.typ) + "__";
		case \float(): return "__" + typToString(expr.typ) + "__";
		case \double(): return "__" + typToString(expr.typ) + "__";
		case \short(): return "__" + typToString(expr.typ) + "__";
		case \boolean(): return "__" + typToString(expr.typ) + "__";
		case \char(): return "__" + typToString(expr.typ) + "__";
		case \byte(): return "__" + typToString(expr.typ) + "__";
		case \long(): return "__" + typToString(expr.typ) + "__";
		//case \void(): return "__" + typToString(expr.typ) + "__";
		case \null(): return "__" + typToString(expr.typ) + "__";
		case \array(_, _): return "__" + typToString(expr.typ) + "__";
	}

	//if (word == expr.name)
	//	return "__" + typToString(expr.typ) + "__";



	return "__" + word + "__";
}

Expression anonymizeVar(Expression expr) {
	if (expr@name ?)
		expr.name = replaceVarName(expr.name, expr);

	return expr;
}


list[Declaration] rewriteAST(list[Declaration] asts) {

	// Modify ast for clone detection.
	units = visit(asts){
		case \Expression expr => anonymizeVar(expr)
	}

    return asts;
}

// bool isSubsumed(set[loc] a, set[loc] b) {
// 	for (src <- a) {
// 		bool subsumed = false;
// 		for (other <- b) {
// 			if (isStrictlyContainedIn(src, other)) {
// 				subsumed = true;
// 				break;
// 			}
// 		}
// 		if (!subsumed)
// 			return false;
// 	}
// 	return true;
// }

// bool checkSubsumption(tuple[node tree, set[loc] locs] a, set[set[loc]] targets) {
// 	for (target <- targets) {
// 		if (isSubsumed(a.locs, target)) {
// 			return true;
// 		}
// 	}
// 	return false;
// }

// map[node, set[loc]] filterTreeSubsumption(list[tuple[node tree, set[loc] locs]] pairs, set[set[loc]] targets) {
// 	if (isEmpty(pairs))
// 		return ();
// 	if (isEmpty(targets))
// 		return ();

// 	tuple[node tree, set[loc] locs] pair = head(pairs);

// 	if (!checkSubsumption(pair, targets))
// 		return (pair.tree: pair.locs) + filterTreeSubsumption(tail(pairs), targets);
// 	else
// 		return filterTreeSubsumption(tail(pairs), targets - {pair.locs});
// }

// bool isOverlapped(set[loc] a, set[loc] b) {
// 	if (size(a) != size(b))
// 		return false;

// 	for (src <- a) {
// 		bool overlapped = false;
// 		for (other <- b) {
// 			if (isOverlapping(src, other)) {
// 				overlapped = true;
// 				break;
// 			}
// 		}
// 		if (!overlapped)
// 			return false;
// 	}
// 	return true;
// }

// list[tuple[node, set[loc]]] getOverlaps(tuple[node tree, set[loc] locs] a, list[tuple[node, set[loc]]] targets) {
// 	list[tuple[node, set[loc]]] overlaps = [];
// 	for (tuple[node tree, set[loc] locs] target <- targets) {
// 		if (isOverlapped(a.locs, target.locs)) {
// 			overlaps += target;
// 		}
// 	}
// 	return overlaps;
// }

// tuple[node tree, set[loc] locs]mergeTrees(tuple[node tree, set[loc] locs] a, tuple[node tree, set[loc] locs] b) {
// 	list[Statement] aStates;
// 	if (Statement body := a.tree[0])
// 		if (list[Statement] statements := body[0])
// 			aStates = statements;

// 	list[Statement] bStates;
// 	if (Statement body := b.tree[0])
// 		if (list[Statement] statements := body[0])
// 			bStates = statements;

// 	node newTree = \empty();
// 	for ([*l, *r] := aStates, l != [], r != []) {
// 		if ([r, *rem] := bStates) {
// 			newTree = makeSubtree(l+r+rem);
// 			break;
// 		}
// 		else if ([*rem, l] := bStates) {
// 			newTree = makeSubtree(rem+l+r);
// 			break;
// 		}
// 	}

// 	// In case of subsumption instead of overlap
// 	if (newTree == \empty()) {
// 		if (size(aStates) >= size(bStates)) {
// 			return a;
// 		} else {
// 			return b;
// 		}
// 	}

// 	set[loc] newSrc = {};
// 	for (src <- a.locs) {
// 		for (other <- b.locs) {
// 			if (isOverlapping(src, other)) {
// 				newSrc += cover([src, other]);
// 				break;
// 			}
// 		}
// 	}

// 	return <newTree, newSrc>;
// }

// map[node, set[loc]] mergeTreeOverlap(list[tuple[node tree, set[loc] locs]] pairs) {
// 	if (isEmpty(pairs))
// 		return ();

// 	tuple[node tree, set[loc] locs] pair = head(pairs);

// 	list[tuple[node tree, set[loc] locs]] others = tail(pairs);

// 	list[tuple[node tree, set[loc] locs]] overlaps = getOverlaps(pair, others);

// 	if (overlaps == [])
// 		return (pair.tree: pair.locs) + mergeTreeOverlap(others);

// 	for (overlap_pair <- overlaps) {
// 		others += mergeTrees(pair, overlap_pair);
// 	}

// 	return mergeTreeOverlap(others - overlaps);
// }



// int mass(node tree) {
// 	int treeMass = 0;

// 	visit(tree) {
// 		case node child: {
// 			treeMass += 1;
// 		}
// 	}

// 	return treeMass;

// }

// node makeSubtree(list[Statement] statements) {
// 	node subTree = makeNode("subTree", \block(statements));
// 	subTree = unsetRec(subTree, {"src", "decl"});

// 	return subTree;
// }

// list[Statement] flattenBlock(list[Statement] unitBlock) {
// 	list[Statement] unit_body = [];

// 	for (statement <- unitBlock) {
// 		switch (statement) {
// 			case state:\block(list[Statement] statements): unit_body += flattenBlock(statements);
// 			case state:\foreach(Declaration parameter, Expression collection, \block(body)): {
// 				foreach_node = state;
// 				foreach_node[2] = \empty();
// 				unit_body += foreach_node + flattenBlock(body);
// 			}
// 			case state:\for(list[Expression] initializers, Expression condition, list[Expression] updaters, \block(body)): {
// 				for_node = state;
// 				for_node[3] = \empty();
// 				unit_body += for_node + flattenBlock(body);
// 			}
// 			case state:\for(list[Expression] initializers, list[Expression] updaters, \block(body)): {
// 				for_node = state;
// 				for_node[2] = \empty();
// 				unit_body += for_node +  flattenBlock(body);
// 			}
// 			case state:\if(Expression condition, \block(thenBranch)): {
// 				if_node = state;
// 				if_node[1] = \empty();
// 				unit_body += if_node +  flattenBlock(thenBranch);
// 			}
// 			case state:\if(Expression condition, \block(thenBranch), \block(elseBranch)): {
// 				if_node = state;
// 				if_node[1] = \empty();
// 				if_node[2] = \empty();
// 				Statement else_node;
// 				if (node elseBlock := state[2])
// 					else_node = setKeywordParameters(\expressionStatement(\simpleName("__elseBranch__")), ("src": elseBlock.src));
// 				unit_body += if_node + flattenBlock(thenBranch) + else_node + flattenBlock(elseBranch);
// 			}
// 			case state:\if(Expression condition, \block(thenBranch), elseBranch): {
// 				if_node = state;
// 				if_node[1] = \empty();
// 				if_node[2] = \empty();
// 				unit_body += if_node + flattenBlock(thenBranch) + flattenBlock([elseBranch]);
// 			}
// 			case state:\switch(Expression expression, list[Statement] statements): {
// 				switch_node = state;
// 				switch_node[1] = [];
// 				unit_body += switch_node+  flattenBlock(statements);
// 			}
// 			case state:\synchronizedStatement(Expression lock, \block(body)): {
// 				sync_node = state;
// 				sync_node[1] = \empty();
// 				unit_body += sync_node +  flattenBlock(body);
// 			}
// 			case state:\try(\block(body), list[Statement] catchClauses): {
// 				try_node = state;
// 				try_node[1] = [];
// 				unit_body += try_node + flattenBlock(body) +  flattenBlock(catchClauses);
// 			}
// 			case state:\try(\block(body), list[Statement] catchClauses, \block(\finally)): {
// 				try_node = state;
// 				try_node[0] = \empty();
// 				try_node[1] = [];
// 				try_node[2] = \empty();
// 				unit_body += try_node +  flattenBlock(body) + flattenBlock(catchClauses) + flattenBlock(\finally);
// 			}
// 			case state:\catch(Declaration exception, \block(body)): {
// 				catch_node = state;
// 				catch_node[1] = \empty();
// 				unit_body += catch_node +  flattenBlock(body);
// 			}
// 			case state:\while(Expression condition, \block(body)): {
// 				while_node = state;
// 				while_node[1] = \empty();
// 				unit_body += while_node + flattenBlock(body);
// 			}
// 			case state:\Statement statement: {
// 				unit_body += statement;
// 			}
// 		}
// 	}

// 	return unit_body;
// }

// void getClonesType2(loc projectLocation) {

// 	list[Declaration] asts = getASTs(projectLocation);

// 	list[Declaration] units = getMethods(asts);

// 	// Modify ast for clone detection.
// 	units = visit(units){
// 		case \Expression expr => anonymizeVar(expr)
// 	}

// 	// Flatten units
// 	units = top-down visit(units){
// 		case mthd:\method(_, _, _, _, \block(statements)): {
// 			mthd[4] = \block(flattenBlock(statements));
// 			insert mthd;
// 		}
// 	}

// 	map[node, set[loc]] subTrees = ();

// 	// Add subtrees to map.
// 	println("Finding duplicate subtrees within units");
// 	int unit_count = size(units);
// 	for (unit <- units) {
// 		if (unit_count % 10 == 0)
// 			println("<unit_count> units to go.");
// 		unit_count -= 1;
// 		if (Statement body := unit[4])
// 			if (list[Statement] statements := body[0])
// 				if (size(statements) >= 6) {
// 					//println("Unit of size: <size(statements)>");
// 					int statement_count = size(statements);
// 					int sub_tree_size = 6;
// 					for (treeStart <- [0..statement_count + 1 - sub_tree_size]) {
// 						start_src = statements[treeStart].src;
// 						end_src = statements[treeStart + sub_tree_size - 1].src;
// 						start_src.length = 1;
// 						end_src.length = end_src.begin.column;
// 						src = cover([start_src, end_src]);

// 						node subTree = makeSubtree(statements[treeStart..treeStart + sub_tree_size]);

// 						if (subTree in subTrees)
// 							subTrees[subTree] += src;
// 						else
// 							subTrees[subTree] = {src};
// 					}
// 				}
// 	}

// 	//for (subTree <- subTrees, size(subTrees[subTree]) == 1) {
// 	//	println(subTree);
// 	//	println("@ <subTrees[subTree]>");
// 	//}
// 	subTrees = (key: subTrees[key] | key <- subTrees, size(subTrees[key]) > 1);



// 	mergedTrees = mergeTreeOverlap(toList(subTrees));
// 	while (size(mergedTrees) < size(subTrees)) {
// 		subTrees = mergedTrees;
// 		mergedTrees = mergeTreeOverlap(toList(subTrees));
// 	}

// 	//subTrees = filterTreeSubsumption(toList(subTrees), range(subTrees));

// 	int count_clone_class = 0;
// 	for (subTree <- subTrees) {
// 		if (|unknown:///| notin subTrees[subTree], subTrees[subTree] != {})
// 			//println(subTree);
// 			println("Clone: ");
// 			println("<subTrees[subTree]>");
// 			println("---");

// 			count_clone_class += 1;
// 	}

// 	println("Number of clone classes: <count_clone_class>");

// }

// map[list[str], set[loc]] getClonesType1(map[str, map[int, map[loc, str]]] locLines) {

// 	for (file <- locLines, fileLOC := locLines[file]) {
// 		for  (line_number <- fileLOC, lineLOC := fileLOC[line_number]) {
// 			for (src <- lineLOC, code := lineLOC[src]) {
// 				locLines[file][line_number][src] = replaceAll(code, " ", "");
// 			}
// 		}
// 	}

// 	// Map all lines and occurrences
// 	map[list[str], set[list[loc]]] duplicates = ();

// 	println("Setting up code lines and metadata");
// 	for (file <- locLines, fileLOC := locLines[file]) {
// 		for  (line_number <- locLines[file], lineLOC := fileLOC[line_number]) {
// 			for (src <- lineLOC, code := lineLOC[src]) {
// 				if ([code] in duplicates)
// 					duplicates[[code]] += {[src]};
// 				else
// 					duplicates[[code]] = {[src]};
// 			}
// 		}
// 	}

// 	// Discard all unique lines.
// 	duplicates = (key: duplicates[key] | key <- duplicates, size(duplicates[key]) > 1);

// 	// Add all largest consecutive lines of code that form a duplicate with another set of lines.
// 	println("Getting duplicate blocks.");
// 	duplicates = getDuplicateBlocks(duplicates, locLines);

// 	// Discard all original single lines of duplicate code.
// 	println("Filtering duplicate blocks");
// 	map[list[str], set[loc]] duplicate_blocks = ();
// 	for (codeLine <- duplicates, size(duplicates[codeLine]) > 1, size(codeLine) > 1) {
// 		duplicate_blocks[codeLine] = {cover([head(locs), last(locs)]) | locs <- (duplicates[codeLine])};
// 	}

// 	// Discard all blocks contained in other blocks
// 	duplicate_blocks = filterSubsumption(duplicate_blocks);

// 	num code_count = sum([size(domain(locLines[file])) | file <- locLines]);
// 	showDuplicateStats(duplicate_blocks, code_count);

// 	return duplicate_blocks;
// }