needs "labeled-module.m2";
needs "complex.m2";

heightFiltration = method();
heightFiltration(LabeledModule) := List =>
(lm) -> (
    n := #((lm.labels#0).big);
    return for i from 0 to n+1 list (
        lm_(positions(lm.labels, (label) -> sum(label.big) >= i))
    );
);
heightFiltration(Complex) := List =>
(c) -> (
    return zipWith(heightFiltration(c.m0), heightFiltration(c.m1), plusplus);
);

loadSS = method();
loadSS(Complex) := (C) -> (
    FC := heightFiltration(C);
    del := (zeroMap(C.m0, C.m0) | C.d1               )
        || (C.d0                | zeroMap(C.m1, C.m1));

    FFunction := p -> trim' FC#(min(max(p,0),#FC-1));
    etaFunction := p -> inducedMap'(trim'(F(p)/F(p+1)), F(p));
    AFunction := (r,p) -> trim'(kernel' inducedMap'(trim'(F(p)/F(p+r)), F(p), del));
    ZFunction := (r,p) -> trim'(image' inducedMap'(, A(r,p), eta(p)));
    BFunction := (r,p) -> trim'(image' inducedMap'(, image' inducedMap'(, A(r-1,p-r+1), del), eta(p)));
    EFunction := (r,p) -> trim'(Z(r,p)/B(r,p));
    EPrimeFunction := (r,p) -> trim'(A(r,p)/(image'(inducedMap'(A(r,p), A(r-1,p-r+1), del)) + A(r-1,p+1)));
    EPrimeToEFunction := (r,p) -> inducedMap'(E(r,p),E'(r,p));
    dFunction := (r,p) -> E'toE(r,p+r) * inducedMap'(E'(r,p+r), E'(r,p), del) * inverse'(E'toE(r,p));
    HFunction := (r,p) -> trim'(kernel'(d(r,p)) / image'(d(r,p-r)));

    functionCache := new MutableHashTable;
    cached := c -> (
        f -> (
            if not c#?f 
            then c#f = new MutableHashTable; 
            (i -> (if not c#f#?i then c#f#i = f(i); c#f#i))));

    F = (cached(functionCache))(FFunction);
    eta = (cached(functionCache))(etaFunction);
    A = (cached(functionCache))(AFunction);
    Z = (cached(functionCache))(ZFunction);
    B = (cached(functionCache))(BFunction);
    E = (cached(functionCache))(EFunction);
    E' = (cached(functionCache))(EPrimeFunction);
    E'toE = (cached(functionCache))(EPrimeToEFunction);
    d = (cached(functionCache))(dFunction);
    H = (cached(functionCache))(HFunction);
);