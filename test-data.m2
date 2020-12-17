needs "complex.m2";

lm0 = labeledModule(ZZ^1/(2*ZZ^1)++ZZ^1/(4*ZZ^1), {"a2","b4"});
lm1 = labeledModule(ZZ^1/(8*ZZ^1)++ZZ^1/(16*ZZ^1), {"c8","d16"});
f = labeledModuleMap(lm1, lm0, map(lm1.m, lm0.m, 1));
g = labeledModuleMap(lm0, lm1, map(lm0.m, lm1.m, 1));
c = complex(f, g);