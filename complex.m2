needs "labeled-module.m2";


-- useless?
Complex = new Type of HashTable;
Complex.synonym = "Z/2-graded curved complex";

complex = method();
complex(LabeledModuleMap, LabeledModuleMap) := Complex =>
	(d0, d1) -> (
			assert (source d0 == target d1);
			assert (target d0 == source d1);

		return new Complex from hashTable {
			(global m0) => source d0,
			(global m1) => source d1,
			(global d0) => d0,
			(global d1) => d1
		}; 	
	);

Complex ++ Complex := Complex =>
(X,Y) -> (
	return complex(X.d0 ++ Y.d0, X.d1 ++ Y.d1);
);

Complex ** Complex := Complex =>
    (X,Y) -> (
		d0 := (X.d0 ** map(Y.m0, Y.m0, 1) | map(X.m1, X.m1, 1) ** Y.d1) 
				|| (map(X.m0, X.m0, 1) ** Y.d0 | -X.d1 ** map(Y.m1, Y.m1, 1));
		d1 := (X.d1 ** map(Y.m0, Y.m0, 1) | map(X.m0, X.m0, 1) ** Y.d1) 
				|| (map(X.m1, X.m1, 1) ** Y.d0 | -X.d0 ** map(Y.m1, Y.m1, 1));
		return complex(d0, d1);
    );

-- the identity Complex for the tensor product
-- 0 -> R -> 0
withZeroDifferential = method();
withZeroDifferential(Ring) := Complex =>
(r) -> (
	return withZeroDifferential(r^1);
);

withZeroDifferential(Module) := Complex =>
(m) -> (
	m0 := m;
	m1 := (ring m)^0;
	d0 := map(m1, m0, 0);
	d1 := map(m0, m1, 0);
	return complex(d0, d1);
);

homology' = method();
homology'(Complex) := Module =>
(c) -> (
	assert (c.d0 * c.d1 == map(c.m1, c.m1, 0) and c.d1 * c.d0 == map(c.m0, c.m0, 0));
	return (kernel c.d0)/(image c.d1) ++ (kernel c.d1)/(image c.d0);
);

toDifferentialModule = method();
toDifferentialModule(Complex) := DifferentialModule =>
(c) -> (
	return labeledDifferentialModule(c.m0 ++ c.m1,
		(map(c.m0, c.m0, 0)  | c.d1               )
     || (c.d0                | map(c.m1, c.m1, 0) ));
)

DifferentialModule = new Type of HashTable;
differentialModule = method();
differentialModule(Module, Matrix) := DifferentialModule =>
(m, d) -> (
	assert (source d == m);
	assert (target d == m);
	assert (d*d == 0);
	return new DifferentialModule from hashTable {
		(global m) => m,
		(global d) => d
	};
);

FilteredDifferentialModule = new Type of HashTable;
filteredDifferentialModule = method();
filteredDifferentialModule(List, Matrix) := FilteredDifferentialModule =>
(filt, differential) -> (
	return new FilteredDifferentialModule from hashTable {
		(global filt) => filt,
		(global d) => differential
	};
);



-- useless?
LabeledComplex = new Type of HashTable;
LabeledComplex.synonym = "Z/2-graded curved complex with labeled generators";

labeledComplex = method();
labeledComplex(LabeledModuleMap, LabeledModuleMap) := LabeledComplex =>
	(d0, d1) -> (
			assert (source d0 == target d1);
			assert (target d0 == source d1);
				-- assert (d1 * d0 == 0);
				-- assert (d0 * d1 == 0);

		return new LabeledComplex from hashTable {
			(global m0) => source d0,
			(global m1) => source d1,
			(global d0) => d0,
			(global d1) => d1
		}; 	
	);

LabeledComplex ++ LabeledComplex := LabeledComplex =>
		(X,Y) -> (
		return labeledComplex(X.d0 ++ Y.d0, X.d1 ++ Y.d1);
		);

tensorC = method();
tensorC(LabeledComplex, LabeledComplex, Function) := LabeledComplex =>
(X, Y, f) -> (
	d0 := (tensorLMM(X.d0, identityMap(Y.m0), f) | tensorLMM(identityMap(X.m1), Y.d1, f)) 
				|| (tensorLMM(identityMap(X.m0), Y.d0, f) | tensorLMM(-X.d1, identityMap(Y.m1), f));
	d1 := (tensorLMM(X.d1, identityMap(Y.m0), f) | tensorLMM(identityMap(X.m0), Y.d1, f)) 
			|| (tensorLMM(identityMap(X.m1), Y.d0, f) | tensorLMM(-X.d0, identityMap(Y.m1), f));
	return labeledComplex(d0, d1);
);

LabeledComplex ** LabeledComplex := LabeledComplex =>
    (X,Y) -> (
		d0 := (X.d0 ** identityMap(Y.m0) | identityMap(X.m1) ** Y.d1) 
				|| (identityMap(X.m0) ** Y.d0 | -X.d1 ** identityMap(Y.m1));
		d1 := (X.d1 ** identityMap(Y.m0) | identityMap(X.m0) ** Y.d1) 
				|| (identityMap(X.m1) ** Y.d0 | -X.d0 ** identityMap(Y.m1));
		return labeledComplex(d0, d1);
    );

-- the identity LabeledComplex for the tensor product
-- 0 -> R -> 0
withZeroDifferential = method();
withZeroDifferential(Ring, HashTable) := LabeledComplex =>
(r, label) -> (
	m0 := labeledModule(r^1, {label});
	m1 := zeroModule(r);
	d0 := labeledModuleMap(m1, m0, map(m1.m, m0.m, 0));
	d1 := labeledModuleMap(m0, m1, map(m0.m, m1.m, 0));
	return labeledComplex(d0, d1);
);

withZeroDifferential(LabeledModule) := LabeledComplex =>
(lm) -> (
	m0 := lm;
	m1 := zeroModule(ring lm.m);
	d0 := labeledModuleMap(m1, m0, map(m1.m, m0.m, 0));
	d1 := labeledModuleMap(m0, m1, map(m0.m, m1.m, 0));
	return labeledComplex(d0, d1);
);

homology' = method();
homology'(LabeledComplex) := LabeledModule =>
(c) -> (
	assert (c.d0 * c.d1 == zeroMap(c.m1, c.m1) and c.d1 * c.d0 == zeroMap(c.m0, c.m0));
	return (kernel' c.d0)/(image' c.d1) ++ (kernel' c.d1)/(image' c.d0);
);

toLabeledDifferentialModule = method();
toLabeledDifferentialModule(LabeledComplex) := DifferentialModule =>
(c) -> (
	return labeledDifferentialModule(c.m0 ++ c.m1,
		(zeroMap(c.m0, c.m0) | c.d1               )
     || (c.d0                | zeroMap(c.m1, c.m1)));
)

LabeledDifferentialModule = new Type of HashTable;

labeledDifferentialModule = method();
labeledDifferentialModule(LabeledModule, LabeledModuleMap) := LabeledDifferentialModule =>
(lm, d) -> (
	assert (source d == lm);
	assert (target d == lm);
	assert (d*d == 0);
	return new LabeledDifferentialModule from hashTable {
		(global lm) => lm,
		(global d) => d
	};
);

LabeledFilteredComplex = new Type of HashTable;
labeledFilteredComplex = method();
labeledFilteredComplex(List) := LabeledFilteredComplex =>
(filt) -> (
	return new LabeledFilteredComplex from hashTable {
		(global filt) => filt
	};
);
