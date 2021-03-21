load "functions.m2";
load "labeled-module.m2";
load "braid.m2";
load "complex.m2";
load "c2minus.m2";
load "spectral-sequence.m2";

truncateOutput 500;

-- b = braid(1,{1});

-- b = braid(2,{2});
-- reso = resolve(b, {0});
-- C = C2Minus(reso);
-- H = trim' homology' C;
-- C = toLabeledDifferentialModule(C2Reduced b);
-- labels = C.lm.labels;
-- loadSS(heightFiltration(differentialModule(C.lm.m, C.d.underlyingMap), C.lm.labels), false);
-- X = select'(D.m, (label) -> sum(label.big) < 1);
-- Y = select'(D.m, (label) -> sum(label.big) < 2);
-- k = kernel'(inducedMap'(Y,X,D.d));
-- H0 = trim'( (kernel' C.d0) / (image' C.d1) );
-- H1 = trim'( (kernel' C.d1) / (image' C.d0) );
-- loadSS(C);

-- br = singularBraid(4,{2,1,3});
-- r = br.r;
-- use r;
-- Q = r^1/(ideal(u1-u4,u2-u5));

-- LDPlus' = (br) -> (
--     vs := keys(br.adjacent);
--     out := withZeroDifferential(br.r, hashTable{(global small) => {}});
--     for i from 0 to #vs-1 do (
--         out = out ** LDPlus(br, vs#i);
--     );
-- 	return out;
-- );

-- C = LDPlus'(br) ** withZeroDifferential(labeledModule(Q, {hashTable{(global small) => {}}}));

br = singularBraid(4,{2,1,3});
r = br.r;
Q = trim (r^1/(ideal(u1-u4,u2-u5)+N(br)+ideal()));

LDPlus' = (br) -> (
    vs := keys(br.adjacent);
    out := withZeroDifferential(br.r, hashTable{(global small) => {}});
    for i from 0 to #vs-1 do (
        if (vs#i).row <= 10 then (
            out = out ** LDPlus(br, vs#i);
        );
    );
	return out;
);

C = LDPlus'(br) ** withZeroDifferential(labeledModule(Q, {hashTable{(global small) => {}}}));

H = trim' homology' C;