GGradedModule = new Type of HashTable;
GGradedModule.synonym = "G-graded module"

gGradedModule = method();
gGradedModule(Ring, Module, List) := GGradedModule =>
    (baseRing, grading, pieces) -> (
	assert (ring grading === ZZ);
	apply(pieces, (piece) -> (
	    assert (module piece#0 == grading);
	    assert (ring piece#1 === baseRing);
	));
	return new GGradedModule from hashTable {
	    (global ring) => baseRing,
	    (global grading) => grading,
	    (global summands) => hashTable pieces
	}; 	
    );

ring GGradedModule := (M) -> M.ring

GGradedModule _ Vector := Module => (M,v) -> if M.summands#?v then M.summands#v else (ring M)^0
