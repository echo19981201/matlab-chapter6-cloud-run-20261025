function validate_three_fisher(v)
A=[2.79 7.8 13.85 49.6;4.67 12.31 22.31 47.8;4.63 16.81 28.82 62.15;3.54 7.58 15.29 43.2;4.9 16.12 28.29 58.7];
B=[1.06 1.22 2.18 20.6;0.8 4.06 3.85 27.1;0 3.5 11.4 0;2.42 2.14 3.66 15;0 5.68 12.1 0];
U=[2.4 14.3 7.9 33.2;5.1 4.43 22.4 54.6];
assert(isequal(v.A,A) && isequal(v.B,B) && isequal(v.U,U),'Fisher input differs from the question.');
assert(strcmp(v.category{1},'乙地') && strcmp(v.category{2},'甲地'),'Wrong unknown-sample classifications.');
muA=mean(A,1);muB=mean(B,1);
scatter=zeros(4);
for k=1:5
    da=A(k,:)-muA;db=B(k,:)-muB;
    scatter=scatter+da'*da+db'*db;
end
assert(rank(scatter)==4,'Fisher scatter matrix must have rank four.');
w=scatter\(muA-muB)';w=w/norm(w);
threshold=(muA+muB)*w/2;
expected=U*w;
assert(abs(norm(v.w)-1)<1e-12,'Fisher w must be unit normalized.');
assert(max(abs(v.w(:)-w))<1e-10,'Fisher direction mismatch.');
assert(abs(v.threshold-threshold)<1e-10,'Fisher threshold mismatch.');
assert(max(abs(v.sU(:)-expected))<1e-10,'Fisher unknown projections mismatch.');
assert(v.sU(1)<v.threshold && v.sU(2)>v.threshold,'Fisher classification signs mismatch.');
assert(all(A*w>threshold) && all(B*w<threshold),'Known samples are not correctly separated.');
fprintf('Verified unknown projections: %.12f, %.12f; threshold: %.12f\n',expected(1),expected(2),threshold);
end
