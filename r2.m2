R=QQ[u1,u2,u3,u4,u5,u6];

L00=ideal(u3+u4-u5-u6);
L10=ideal(0);
L01=ideal(u3+u4-u5-u6,u5+u6-u1-u2);
L11=ideal(u5+u6-u1-u2);

N00=ideal(u1-u5,u2-u6,u3*u4-u5*u6);
N10=ideal(u1-u3,u1-u5,u2-u4,u2-u6);
N01=ideal(u1*u2-u5*u6,u1*u2-u3*u4);
N11=ideal(u3-u5,u4-u6,u1*u2-u5*u6);

I00=N00+L00;
I10=N10+L10;
I01=N01+L01;
I11=N11+L11;

q = (R,I) -> (R^1)/(I*R^1);

C00 = (q(R,I00))^2;
d00 = map(C00, C00, {(1,0) => u1+u2-u3-u4, (0,1) => u1+u2+u3+u4});