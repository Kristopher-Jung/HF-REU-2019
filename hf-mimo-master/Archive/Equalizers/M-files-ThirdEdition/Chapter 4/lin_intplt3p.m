 function XXX = lin_intplt3p(X)
% XXX = lin_intplt3p(X)
% Linear interpolation of vector X by inserting three additional
% samples between successive samples of vector X.
% X = The input vector.
% XXX = The interpolated vector.
% intv = The distance between any two successive samples.

l = size(X,2);
XXX = zeros(1,4*l);
XXX(1) = 0.25 * X(1);
XXX(2) = 0.50 * X(1);
XXX(3) = 0.75 * X(1);
XXX(4) = X(1);
    
for i = 2:l
    XXX(4*i) = X(i);
    intv = X(i) - X(i-1);
    XXX(4*i-3) = X(i-1) + 0.25 * intv;
    XXX(4*i-2) = X(i-1) + 0.50 * intv;
    XXX(4*i-1) = X(i-1) + 0.75 * intv;
end