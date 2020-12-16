-- probably useless

GGradedModule = new Type of HashTable;
GGradedModule.synonym = "G-graded module"

gGradedModule = method();
gGradedModule(Ring, Module, HashTable) := GGradedModule =>
    (baseRing, grading, summands) -> (
		assert (ring grading === ZZ);
		scanPairs(summands, (k,v) -> (
			assert (module k == grading);
			assert (ring v === baseRing);
		));
		return new GGradedModule from hashTable {
			(global ring) => baseRing,
			(global grading) => grading,
			(global summands) => summands
		}; 	
    );

gGradedModule(Ring, Module, List) := GGradedModule =>
    (baseRing, grading, summands) -> (
		return gGradedModule(baseRing, grading, hashTable summands);
    );

GGradedModule ++ GGradedModule := GGradedModule =>
    (M,N) -> (
		assert (M.ring === N.ring);
		assert (M.grading == N.grading);
		return gGradedModule(M.ring, M.grading, merge(M.summands, N.summands, (a,b) -> a ++ b));
    );

GGradedModule ** GGradedModule := GGradedModule =>
    (M,N) -> (
		assert (M.ring === N.ring);
		newGrading := M.grading ++ N.grading;
		inM := newGrading_[0];
		inN := newGrading_[1];
		return gGradedModule(M.ring, newGrading,
			combine(
			M.summands,
			N.summands,
			(kM, kN) -> inM(kM) + inN(kN),
			(a,b) -> a ** b,
			error));
    );

ring GGradedModule := (M) -> M.ring
GGradedModule _ Vector := Module => (M,v) -> if M.summands#?v then M.summands#v else (ring M)^0

GGradedModuleMap = new Type of HashTable;
GGradedModuleMap.synonym = "map of G-graded modules"

gGradedModuleMap = method();
gGradedModuleMap(GGradedModule, GGradedModule, HashTable) := GGradedModuleMap =>
    (N, M, summands) -> (
		assert (ring M === ring N);
		assert (M.grading == N.grading);
		scanPairs(summands, (g,f) -> (
			assert (module g == M.grading);
			assert (source f == M_g);
			assert (target f == N_g);
		));
		return new GGradedModuleMap from hashTable {
			(global source) => M,
			(global target) => N,
			(global summands) => summands
		};
	);
gGradedModuleMap(GGradedModule, GGradedModule, List) := GGradedModuleMap =>
	(N, M, summands) -> (
		return gGradedModuleMap(N, M, hashTable summands);
	);
