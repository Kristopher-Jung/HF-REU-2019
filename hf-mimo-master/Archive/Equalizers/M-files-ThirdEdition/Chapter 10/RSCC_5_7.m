function [c_s c_p] = RSCC_5_7(N)
%RSCC_5_7 Generates a trellis of depth N for a 5/7 RSCC.
%   	  [C_S C_P] = RSCC_5_7(N)
%         N is the depth of the trellis
%         C_S and C_P are systematic and parity check bits.


Ns = 4;                 % Number of states
c_s = zeros(Ns^2,N);    % Initiation of the matrix of systematic bits
c_p = zeros(Ns^2,N);    % Initiation of the matrix of parity check bits
for i = 1 : N           % Time index
    c_s(1,i) = 0; c_p(1,i) = 0;
    c_s(3,i) = 1; c_p(3,i) = 1;
    if i > 1
        c_s(10,i) = 0; c_p(10,i) = 0;
        c_s(12,i) = 1; c_p(12,i) = 1;
        if i > 2
            c_s(5,i) = 0;  c_p(5,i) = 1;
            c_s(7,i) = 1;  c_p(7,i) = 0;
            c_s(14,i) = 1; c_p(14,i) = 1;
            c_s(16,i) = 0; c_p(16,i) = 0;
        end
    end
end