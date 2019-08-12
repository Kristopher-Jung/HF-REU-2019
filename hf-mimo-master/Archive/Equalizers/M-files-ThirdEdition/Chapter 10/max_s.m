function x_s = max_s(x)
%MAX_S Calculates the max* of the elements of vector x.
%   X_S = MAX_S(X) calculats the max* of the elements of vetor x by
%   recursively performing the max* operation on two of the elements of 
%   vector x at each recursion.

L = length(x);
x_s = x(1);
if L > 1
    for l = 2 : L
        x_s = max_s_2(x_s,x(l));    % max* of the two elements x_s and x(l)
    end
end