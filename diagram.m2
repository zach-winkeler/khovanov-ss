CrossingType = new Type of ZZ;
POSITIVE = 0;
NEGATIVE = 1;
SINGULAR = 2;
PUNCTURE = 3;

Crossing = new Type of HashTable;
crossing = method();
crossing(ZZ, CrossingType) := Crossing =>
(i, type) -> (
    return new Crossing from hashTable {
        (global i) => i,
        (global type) => type
    };
);

-- punctured diagram of a partially-singular braid
Braid = new Type of HashTable;
braid = method();
braid(List) := Braid =>
(crossings) -> (
    assert(number(crossings, (crossing) -> crossing.type == PUNCTURE) == 1);

    return new Braid from hashTable {
        (global crossings) => crossings
    };
);

-- punctured diagram of a resolution of a partially-singular braid
BraidRes = new Type of HashTable;
braidRes = method();
braidRes(Braid, List) := BraidRes =>
(b, I) -> (
    return new BraidRes from hashTable {
        (global parent) => b,
        (global resolution) => I
    };
);

resolve = method();
resolve(Braid, List) := BraidRes =>
(b, I) -> (
    return braidRes(b, I);
);