load "functions.m2";
load "labeled-module.m2";
load "braid.m2";
load "complex.m2";
load "c2minus.m2";
load "spectral-sequence.m2";

truncateOutput 500;

b = braid(2,{2,-1,-2});
reso = resolve(b, {0,1,0});
C = C2Minus(reso);
H = trim' homology' C;
genDescriptions = describeGenerators(H);
-- C = toLabeledDifferentialModule(C2Reduced b);
-- labels = C.lm.labels;
-- loadSS(heightFiltration(differentialModule(C.lm.m, C.d.underlyingMap), C.lm.labels), false);
-- X = select'(D.m, (label) -> sum(label.big) < 1);
-- Y = select'(D.m, (label) -> sum(label.big) < 2);
-- k = kernel'(inducedMap'(Y,X,D.d));
-- H0 = trim'( (kernel' C.d0) / (image' C.d1) );
-- H1 = trim'( (kernel' C.d1) / (image' C.d0) );
-- loadSS(C);