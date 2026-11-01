syms s
P=s^6+10*s^5+42*s^4+96*s^3+125*s^2+86*s+24;
Q=s^5+5*s^4+12*s^3+28*s^2+35*s+15;
G=gcd(P,Q);
L=lcm(P,Q);
disp('最大公约数');disp(factor(G))
disp('最小公倍数');disp(factor(L))
disp('最小公倍数展开');disp(expand(L))
