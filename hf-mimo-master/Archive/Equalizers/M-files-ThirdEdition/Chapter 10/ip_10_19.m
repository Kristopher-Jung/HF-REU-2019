% MATLAB script for Illustrative Problem 10.19

y = [1.2 -0.8 0.3 .02 -0.7 -0.02 2 0 -1 1];
Ns = 4;                             % Number of states
E = 1;                              % Energy per symbol
EbN0_dB=1;                          % SNR per bit (dB)
% Computing gamma:
gamma = gamma_calc(y,E,EbN0_dB);    % y is the channel output
