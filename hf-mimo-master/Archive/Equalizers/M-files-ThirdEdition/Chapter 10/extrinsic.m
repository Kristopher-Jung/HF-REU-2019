function [L_e L] = extrinsic(y,E,EbN0_dB,P)
%EXTRINSIC Generates the extrinsic information and output LLR's for a 5/7 RSCC
%          with BPSK modulation over an AWGN channel.
%   	   [L_e L] = extrinsic(y,E,EbN0_dB,P)
%          y: channel output sequence
%          E: symbol energy
%          EbN0_dB: SNR/bit in dB
%          P: A priori probabilities of input bits
M = length(y);              % Length of channel output sequence
N = M/2;                    % Depth of Trellis
Ns = 4;                     % Number of states
y_s = y(1:2:M-1);           % Systematic components of y
y_p = y(2:2:M);             % Parity-check components of y
[c_s c_p] = RSCC_5_7(N);    % Generation of the 5/7 RSCC trellis
Eb = 2*E;
N0 = Eb*10^(-EbN0_dB/10);   % Noise variance
gamma = gamma_calc(y,E,EbN0_dB);
gamma_t = log(gamma);
[alpha_t alpha_0_t] = forward_recursion_log(gamma_t);
beta_t = backward_recursion_log(gamma_t);
% Initialization for speed:
L_e = zeros(1,N);
L = zeros(1,N);
for i = 1 : N               % Time index
    if i == 1
        u1 = alpha_0_t + 2*y_p(i)*c_p(3,i)/N0 + beta_t(3,i);
        v1 = alpha_0_t + 2*y_p(i)*c_p(1,i)/N0 + beta_t(1,i);
        L_e(i) = max_s(u1) - max_s(v1);
    elseif i == 2
        u1 = alpha_t(1,i-1) + 2*y_p(i)*c_p(3,i)/N0 + beta_t(3,i);
        u2 = alpha_t(3,i-1) + 2*y_p(i)*c_p(12,i)/N0 + beta_t(4,i);
        v1 = alpha_t(1,i-1) + 2*y_p(i)*c_p(1,i)/N0 + beta_t(1,i);
        v2 = alpha_t(3,i-1) + 2*y_p(i)*c_p(10,i)/N0 + beta_t(2,i);
        L_e(i) = max_s([u1 u2]) - max_s([v1 v2]);
    elseif i == N-1
        u1 = alpha_t(4,i-1) + 2*y_p(i)*c_p(14,i)/N0 + beta_t(2,i);
        v1 = alpha_t(1,i-1) + 2*y_p(i)*c_p(1,i)/N0 + beta_t(1,i);
        v2 = alpha_t(2,i-1) + 2*y_p(i)*c_p(5,i)/N0 + beta_t(1,i);
        v3 = alpha_t(3,i-1) + 2*y_p(i)*c_p(10,i)/N0 + beta_t(2,i);
        L_e(i) = max_s(u1) - max_s([v1 v2 v3]);
    elseif i == N
        v1 = alpha_t(1,i-1) + 2*y_p(i)*c_p(1,i)/N0 + beta_t(1,i);
        v2 = alpha_t(2,i-1) + 2*y_p(i)*c_p(5,i)/N0 + beta_t(1,i);
        L_e(i) = - max_s([v1 v2]);
    else
        u1 = alpha_t(1,i-1) + 2*y_p(i)*c_p(3,i)/N0 + beta_t(3,i);
        u2 = alpha_t(2,i-1) + 2*y_p(i)*c_p(7,i)/N0 + beta_t(3,i);
        u3 = alpha_t(3,i-1) + 2*y_p(i)*c_p(12,i)/N0 + beta_t(4,i);
        u4 = alpha_t(4,i-1) + 2*y_p(i)*c_p(14,i)/N0 + beta_t(2,i);
        v1 = alpha_t(1,i-1) + 2*y_p(i)*c_p(1,i)/N0 + beta_t(1,i);
        v2 = alpha_t(2,i-1) + 2*y_p(i)*c_p(5,i)/N0 + beta_t(1,i);
        v3 = alpha_t(3,i-1) + 2*y_p(i)*c_p(10,i)/N0 + beta_t(2,i);
        v4 = alpha_t(4,i-1) + 2*y_p(i)*c_p(16,i)/N0 + beta_t(4,i);
        L_e(i) = max_s([u1 u2 u3 u4]) - max_s([v1 v2 v3 v4]);
    end
    L(i) = 4*sqrt(E)*y_s(i)/N0 + log(P(i)/(1-P(i))) + L_e(i);   % LLR values
end