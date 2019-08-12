function c = max_s_2(a,b)
%MAX_S_2 Calculates the max* of the two numbers.
%   C = MAX_S_2(A,B) calculats the max* of a and b.

c = max(a,b) + log(1+exp(-abs(a-b)));