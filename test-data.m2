load "functions.m2";
load "labeled-module.m2";
load "braid.m2";
load "complex.m2";
load "c2minus.m2";
load "spectral-sequence.m2";

truncateOutput 500;

b = braid(2,{2,2,2});
C = C2Reduced b;
loadSS(C);