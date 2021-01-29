-- trim' = Q -> 
--     image(generators Q)/
--         intersect(image generators Q, image relations Q)
        
actions = M -> 
    for i from 0 to numColumns(gens(M))-1 
        list basis((ring M)/(ann((ring M)*(M_i))))

zipWith = method();
zipWith(List, List, Function) := List =>
(l1, l2, f) -> (
    assert(#l1 == #l2);
    return for i from 0 to #l1-1 list f(l1#i, l2#i);
);

plusplus = (x,y) -> x ++ y