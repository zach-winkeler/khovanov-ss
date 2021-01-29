LabeledModule = new Type of HashTable;
labeledModule = method();
labeledModule(Module, List) := LabeledModule =>
(m, labels) -> (
	assert (numgens (ambient m) == #labels);
	return new LabeledModule from hashTable({
		(global m) => m,
		(global labels) => labels
	});
);

LabeledModule == LabeledModule := Boolean =>
(lm1, lm2) -> (
		return lm1.m == lm2.m and lm1.labels === lm2.labels;
);

zeroModule = method();
zeroModule(Ring) := LabeledModule =>
(r) -> (
	return labeledModule(r^0, {});
)

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
		return tensorLM(lm1, lm2, (l1, l2) -> merge(l1, l2, (i,j) -> i | j));
);

LabeledModule _ List := LabeledModule =>
(lm, genList) -> (
	return labeledModule(subquotient((lm.m)_genList,), lm.labels);
);

trim' = method();
trim'(LabeledModule) := LabeledModule =>
(lm) -> (
	return labeledModule(trim lm.m, lm.labels);
);

LabeledModule / LabeledModule := LabeledModule =>
(lm1, lm2) -> (
	return labeledModule(lm1.m/lm2.m, lm1.labels);
);

actions(LabeledModule) := List =>
(lm) -> (
	return actions lm.m;
);

describeGenerator = method();
describeGenerator(LabeledModule, ZZ) := HashTable =>
(lm, n) -> (
    coeffs := entries((lm.m)_n);
	nonZeroEntries := select(zip(lm.labels, coeffs), (label, c) -> c != 0);
	return hashTable {
		(global linearCombination) => hashTable(apply(nonZeroEntries, (label, c) -> label => c)),
		(global actions) => actions lm_{n}
	};
);

describeGenerators = method();
describeGenerators(LabeledModule) := List =>
(lm) -> (
	return for i from 0 to (numgens lm.m)-1 list (
		describeGenerator(lm, i)
	);
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

LabeledModuleMap == LabeledModuleMap := Boolean =>
(f1, f2) -> (
		return (f1.source == f2.source) and (f1.target == f2.target) and (f1.underlyingMap == f2.underlyingMap);
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

zeroMap = method();
zeroMap(LabeledModule, LabeledModule) := LabeledModuleMap =>
(m1, m0) -> (
	return labeledModuleMap(m1, m0, map(m1.m, m0.m, 0));
);

tensorLMM = method();
tensorLMM(LabeledModuleMap, LabeledModuleMap, Function) := LabeledModuleMap =>
(f1, f2, labelf) -> (
	return labeledModuleMap(
		tensorLM(f1.target, f2.target, labelf),
		tensorLM(f1.source, f2.source, labelf),
		f1.underlyingMap ** f2.underlyingMap
	);
);

LabeledModuleMap ** LabeledModuleMap := LabeledModuleMap =>
(f1, f2) -> (
		return labeledModuleMap(
			f1.target ** f2.target,
			f1.source ** f2.source,
			f1.underlyingMap ** f2.underlyingMap);
);

LabeledModuleMap * LabeledModuleMap := LabeledModuleMap =>
(f1, f2) -> (
	assert (f1.source == f2.target);
		return labeledModuleMap(
			f1.target,
			f2.source,
			f1.underlyingMap * f2.underlyingMap);
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

kernel' = method();
kernel'(LabeledModuleMap) := LabeledModule =>
(f) -> (
	return labeledModule(kernel (f.underlyingMap), f.source.labels);
);

image' = method();
image'(LabeledModuleMap) := LabeledModule =>
(f) -> (
	return labeledModule(image f.underlyingMap, f.target.labels);
);

inducedMap' = method();
inducedMap'(LabeledModule, LabeledModule) := LabeledModuleMap =>
(t, s) -> (
	return labeledModuleMap(t, s, inducedMap(t.m, s.m));
);
inducedMap'(LabeledModule, LabeledModule, LabeledModuleMap) := LabeledModuleMap =>
(t, s, f) -> (
	return labeledModuleMap(t, s, inducedMap(t.m, s.m, f.underlyingMap));
);
inducedMap'(Nothing, LabeledModule, LabeledModuleMap) := LabeledModuleMap =>
(t, s, f) -> (
	return labeledModuleMap(target f, s, inducedMap(, s.m, f.underlyingMap));
);