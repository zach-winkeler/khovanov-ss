LabeledModule = new Type of HashTable;
labeledModule = method();
labeledModule(Module, List) := LabeledModule =>
(m, labels) -> (
	return new LabeledModule from hashTable({
		(global m) => m,
		(global labels) => labels
	});
);

LabeledModule == LabeledModule := Boolean =>
(lm1, lm2) -> (
		return lm1.m == lm2.m and lm1.labels == lm2.labels;
);

LabeledModule ++ LabeledModule := LabeledModule =>
(lm1, lm2) -> (
		return labeledModule(lm1.m ++ lm2.m, lm1.labels | lm2.labels);
);

List ** List := List =>
	(l1, l2) -> (
		return fold((acc1, e1) -> acc1 | 
			fold((acc2, e2) -> acc2 | {{e1,e2}}, {}, l2), {}, l1);
);

tensorLM = method();
tensorLM(LabeledModule, LabeledModule, Function) := LabeledModule =>
	(lm1, lm2, f) -> (
		m := lm1.m ** lm2.m;
		labels := apply(lm1.labels ** lm2.labels, l -> f toSequence l);
		return labeledModule(m, labels);
);

LabeledModule ** LabeledModule := LabeledModule =>
	(lm1, lm2) -> (
		return tensorLM(lm1, lm2, (l1, l2) -> "(" | l1 | "," | l2 | ")");
);

LabeledModuleMap = new Type of HashTable;
labeledModuleMap = method();
labeledModuleMap(LabeledModule, LabeledModule, ModuleMap) := LabeledModuleMap =>
(lmt, lms, f) -> (
		assert (source f == lms.m);
		assert (target f == lmt.m);
		return new LabeledModuleMap from hashTable({
				(global source) => lms,
				(global target) => lmt,
				(global underlyingMap) => f 
		});
);

identityMap = method();
identityMap(LabeledModule) := LabeledModuleMap =>
(lm) -> (
	return labeledModuleMap(lm, lm, map(lm.m, lm.m, 1));
);

source LabeledModuleMap := LabeledModule =>
(lm) -> (
		return lm.source;
);

target LabeledModuleMap := LabeledModule =>
(lm) -> (
		return lm.target;
);

- LabeledModuleMap := LabeledModuleMap =>
(f) -> (
	return labeledModuleMap(f.target, f.source, -f.underlyingMap);
);

LabeledModuleMap ++ LabeledModuleMap := LabeledModuleMap =>
(f1, f2) -> (
		return labeledModuleMap(
			f1.target ++ f2.target,
			f1.source ++ f2.source,
			f1.underlyingMap ++ f2.underlyingMap);
);

LabeledModuleMap ** LabeledModuleMap := LabeledModuleMap =>
(f1, f2) -> (
		return labeledModuleMap(
			f1.target ** f2.target,
			f1.source ** f2.source,
			f1.underlyingMap ** f2.underlyingMap);
);

LabeledModuleMap | LabeledModuleMap := LabeledModuleMap =>
(f1, f2) -> (
	assert (target f1 == target f2);
	return labeledModuleMap(
		f1.target,
		f1.source ++ f2.source,
		f1.underlyingMap | f2.underlyingMap);
);

LabeledModuleMap || LabeledModuleMap := LabeledModuleMap =>
(f1, f2) -> (
	assert (source f1 == source f2);
	return labeledModuleMap(
		f1.target ++ f2.target,
		f1.source,
		f1.underlyingMap || f2.underlyingMap);
);