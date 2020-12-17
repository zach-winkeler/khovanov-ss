needs "labeled-module.m2";

-- useless?
Complex = new Type of HashTable;
Complex.synonym = "Z/2-graded chain complex with labeled generators";

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

Complex ** Complex := Complex =>
    (X,Y) -> (
		d0 := (X.d0 ** identityMap(Y.m0) | identityMap(X.m1) ** Y.d1) 
				|| (identityMap(X.m0) ** Y.d0 | -X.d1 ** identityMap(Y.m1));
		d1 := (X.d1 ** identityMap(Y.m0) | identityMap(X.m0) ** Y.d1) 
				|| (identityMap(X.m1) ** Y.d0 | -X.d0 ** identityMap(Y.m1));
		return complex(d0, d1);
    );