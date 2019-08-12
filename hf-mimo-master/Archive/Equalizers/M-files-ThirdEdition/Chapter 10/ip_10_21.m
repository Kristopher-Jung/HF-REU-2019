% MATLAB script for Illustrative Problem 10.21

y=[1.2 -0.8 0.3 .02 -0.7 -0.02 2 0 -1 1];
Ns = 4;                         % Number of states                     
E = 1;                          % Energy per bit
EbN0_dB=10;                     % SNR/bit in dB
% Calculation of gamma, alpha, and beta in the logarithmic domain:
gamma = gamma_calc(y,E,EbN0_dB);
gamma_t = log(gamma);
[alpha_t alpha_t_0] = forward_recursion_log(gamma_t);
beta_t = backward_recursion_log(gamma_t);