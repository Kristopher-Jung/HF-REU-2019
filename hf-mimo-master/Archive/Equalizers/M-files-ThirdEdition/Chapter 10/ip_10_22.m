% MATLAB script for Illustrative Problem 10.22

y=[1.2 -0.8 0.3 .02 -0.7 -0.02 2 0 -1 1];
E = 1;                      % Bit energy
EbN0_dB = 10;               % SNR/bit in dB
P = ones(1,length(y)/2)/2;            % A priori probability of each bit initialized to 1/2
[L_e L] = extrinsic(y,E,EbN0_dB,P);