LabeledModule = new Type of HashTable;
labeledModule = method();
labeledModule(Module, List) := LabeledModule =>
(m, labels) -> (
    return new LabeledModule from hashTable({
        (global m) => m,
        (global labels) => labels
    });
);

List ** List := List =>
(l1, l2) -> (
    return fold((acc1, e1) -> acc1 | 
        fold((acc2, e2) -> acc2 | {{e1,e2}}, {}, l2), {}, l1);
);

tensorLM = method();
tensorLM(LabeledModule, LabeledModule, Function) := LabeledModule =>
    (lm1, lm2, f) -> (
        m := lm1.m ** lm2.m;
        labels := apply(lm1.labels ** lm2.labels, l -> f toSequence l);
        return labeledModule(m, labels);
    );

LabeledModule ** LabeledModule := LabeledModule =>
    (lm1, lm2) -> (
        return tensorLM(lm1, lm2, (l1, l2) -> "(" | l1 | "," | l2 | ")");
    );