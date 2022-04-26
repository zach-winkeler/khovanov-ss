-- trim' = Q -> 
--     image(generators Q)/
--         intersect(image generators Q, image relations Q)
actions = method();        
actions(Module) := List =>
(m) ->
    for i from 0 to numColumns(gens(m))-1 
        list basis((ring m)/(ann((ring m)*(m_i))));

zipWith = method();
zipWith(List, List, Function) := List =>
(l1, l2, f) -> (
    assert(#l1 == #l2);
    return for i from 0 to #l1-1 list f(l1#i, l2#i);
);

plusplus = (x,y) -> x ++ y

-- outputs a new hash table with values as keys and vice versa
invertTable = method();
invertTable(MutableHashTable) := (ht) -> (
    out := new MutableHashTable;
    htkeys := keys(ht);
    
    for i from 0 to #htkeys-1 do (
	out#(ht#(htkeys#i)) = htkeys#i;
    );

    return out;
);