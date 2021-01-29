needs "labeled-module.m2";

-- useless?
Complex = new Type of HashTable;
Complex.synonym = "Z/2-graded curved complex with labeled generators";

complex = method();
complex(LabeledModuleMap, LabeledModuleMap) := Complex =>
	(d0, d1) -> (
			assert (source d0 == target d1);
			assert (target d0 == source d1);
				-- assert (d1 * d0 == 0);
				-- assert (d0 * d1 == 0);

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

tensorC = method();
tensorC(Complex, Complex, Function) := Complex =>
(X, Y, f) -> (
	d0 := (tensorLMM(X.d0, identityMap(Y.m0), f) | tensorLMM(identityMap(X.m1), Y.d1, f)) 
				|| (tensorLMM(identityMap(X.m0), Y.d0, f) | tensorLMM(-X.d1, identityMap(Y.m1), f));
	d1 := (tensorLMM(X.d1, identityMap(Y.m0), f) | tensorLMM(identityMap(X.m0), Y.d1, f)) 
			|| (tensorLMM(identityMap(X.m1), Y.d0, f) | tensorLMM(-X.d0, identityMap(Y.m1), f));
	return complex(d0, d1);
);

Complex ** Complex := Complex =>
    (X,Y) -> (
		d0 := (X.d0 ** identityMap(Y.m0) | identityMap(X.m1) ** Y.d1) 
				|| (identityMap(X.m0) ** Y.d0 | -X.d1 ** identityMap(Y.m1));
		d1 := (X.d1 ** identityMap(Y.m0) | identityMap(X.m0) ** Y.d1) 
				|| (identityMap(X.m1) ** Y.d0 | -X.d0 ** identityMap(Y.m1));
		return complex(d0, d1);
    );

-- the identity complex for the tensor product
-- 0 -> R -> 0
withZeroDifferential = method();
withZeroDifferential(Ring) := Complex =>
(r) -> (
	m0 := labeledModule(r^1, {hashTable({})});
	m1 := zeroModule(r);
	d0 := labeledModuleMap(m1, m0, map(m1.m, m0.m, 0));
	d1 := labeledModuleMap(m0, m1, map(m0.m, m1.m, 0));
	return complex(d0, d1);
);

withZeroDifferential(LabeledModule) := Complex =>
(lm) -> (
	m0 := m;
	m1 := zeroModule(ring lm.m);
	d0 := labeledModuleMap(m1, m0, map(m1.m, m0.m, 0));
	d1 := labeledModuleMap(m0, m1, map(m0.m, m1.m, 0));
	return complex(d0, d1);
);

homology' = method();
homology'(Complex) := LabeledModule =>
(c) -> (
	assert (c.d0 * c.d1 == zeroMap(c.m1, c.m1) and c.d1 * c.d0 == zeroMap(c.m0, c.m0));
	return (kernel' c.d0)/(image' c.d1) ++ (kernel' c.d1)/(image' c.d0);
);