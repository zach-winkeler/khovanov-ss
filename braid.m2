CrossingType = new Type of ZZ;

POSITIVE = new CrossingType from 0;
NEGATIVE = new CrossingType from 1;
SINGULAR = new CrossingType from 2;
PUNCTURE = new CrossingType from 3;

Crossing = new Type of HashTable;
crossing = method();
crossing(ZZ, CrossingType) := Crossing =>
(pos, type) -> (
    assert(if type === PUNCTURE then pos == 1 else true);
    return new Crossing from hashTable {
        (global pos) => pos,
        (global type) => type
    };
);

Crossing == Crossing := Boolean =>
(c1, c2) -> (
    return c1.pos == c2.pos and c1.type == c2.type;
);

positive = method();
positive(ZZ) := Crossing =>
(pos) -> (
    return crossing(pos, POSITIVE);
);

negative = method();
negative(ZZ) := Crossing =>
(pos) -> (
    return crossing(pos, NEGATIVE);
);

singular = method();
singular(ZZ) := Crossing =>
(pos) -> (
    return crossing(pos, SINGULAR);
);

puncture = 
() -> (
    return crossing(1, PUNCTURE);
);

-- punctured diagram of a partially-singular braid
Braid = new Type of HashTable;
braid = method();
braid(ZZ, List) := Braid =>
(n, crossings) -> (
    assert(n >= 1);
    assert(all(crossings, (crossing) -> 1 <= crossing.pos and crossing.pos < n));
    assert(number(crossings, (crossing) -> crossing.type === PUNCTURE) == 1);

    return new Braid from hashTable {
        (global n) => n,
        (global crossings) => crossings,
        (global R) => 
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

-- alias
resolve = braidRes;

