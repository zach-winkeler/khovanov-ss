-- probably useless

Z2GradedChainComplex = new Type of HashTable;
Z2GradedChainComplex.synonym = "Z/2-graded chain complex"

z2GradedChainComplex = method();
z2GradedChainComplex(ModuleMap, ModuleMap) := Z2GradedChainComplex =>
    (d0, d1) -> (
		assert (source d0 == target d1);
        assert (target d0 == source d1);
        assert (d1 * d0 == 0);
        assert (d0 * d1 == 0);

		return new Z2GradedChainComplex from hashTable {
            (global c0) => source d0,
            (global c1) => source d1,
			(global d0) => d0,
			(global d1) => d1
		}; 	
    );

Z2GradedChainComplex ++ Z2GradedChainComplex := Z2GradedChainComplex =>
    (X,Y) -> (
		return z2GradedChainComplex(X.d0 ++ Y.d0, X.d1 ++ Y.d1);
    );

identityMap = method();
identityMap(Module) := (M) -> (
    return map(M, M, 1);
);

Z2GradedChainComplex ** Z2GradedChainComplex := Z2GradedChainComplex =>
    (X,Y) -> (
		d0 := (X.d0 ** identityMap(Y.c0) || identityMap(X.c0) ** Y.d0) 
				| (-X.d1 ** identityMap(Y.c1) || identityMap(X.c1) ** Y.d1);
		d1 := (X.d1 ** identityMap(Y.c0) | identityMap(X.c0) ** Y.d1)
				|| (-X.d0 ** identityMap(Y.c1) | identityMap(X.c1) ** Y.d0); 
		return z2GradedChainComplex(d0, d1);
    );

A = ZZ^1 ++ (ZZ^1) / (2*ZZ^1);
B = ZZ^1;
f = map(B, A, {(0,0) => 2});
g = map(A, B, {(1,0) => 1});
C = z2GradedChainComplex(f, g);