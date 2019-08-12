function u{end} = my_dfe(H_est, y, num_taps)
[Q, R] = qr(H_est);
K = pinv(diag(R));
KR = K*R;
dim = size(KR);
B = eye(dim(1),dim(2)) - KR;
w = Q.'*y.';
t = K*w;
u{1} = t;
for n = 1 : num_taps
    u{n+1} = u{n}+B;
end
end