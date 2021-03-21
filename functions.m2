-- logical XOR
-- why is this not built in to Macaulay2
XOR = method();
XOR(Boolean, Boolean) := Boolean => (a,b) -> if a then not b else b;

aggressiveTrim = Q -> 
    image(generators Q)/
        intersect(image generators Q, image relations Q);

actions = method();        
actions(Module) := List =>
(m) ->
    for i from 0 to numColumns(gens(m))-1 
        list basis((ring m)/(ann((ring m)*(m_i))));

zip = method();
zip(List, List) := List =>
(l1, l2) -> (
    assert(#l1 == #l2);
    return for i from 0 to #l1-1 list (l1#i, l2#i);
);

zipWith = method();
zipWith(List, List, Function) := List =>
(l1, l2, f) -> (
    return apply(zip(l1, l2), f);
);

plusplus = (x,y) -> x ++ y

findAndReplace = method();
findAndReplace(HashTable, List) := List =>
(t, l) -> (
    return apply(l, (ele) -> if t#?ele then t#ele else ele);
);