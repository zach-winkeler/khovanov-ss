LabeledModule = new Type of HashTable;
labeledModule = method();
labeledModule(Module, List) := LabeledModule =>
(m, labels) -> (
    return new LabeledModule from hashTable({
        (global m) => m,
        (global labels) => labels
    });
);

LabeledModule ** LabeledModule := LabeledModule =>
    (lm1, lm2) -> (
        m := lm1.m ** lm2.m;
        
    );