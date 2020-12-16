needs "c2minus.m2"

truncateOutput 500;

Homology = method();
Homology(DifferentialGradedModule) := (dgm) -> (
    return trim trim' trim ((kernel dgm.d) / (image dgm.d));
);

-- b = braid(2,{2,2,2});
-- C = C2Reduced(b);
-- loadSS(C);

b = braid(1,{});
C = C2Minus(b);
H = Homology(C);
R = ring C.m;
C' = differentialGradedModule(R^2, map(R^2, R^2, {(1,0) => R_0}), {0,1});
C'' = C' ** C;
H'' = Homology(C'');
