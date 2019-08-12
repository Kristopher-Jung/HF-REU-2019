function gamma = gamma_calc(y,E,EbN0_dB)
%GAMMA_CALC Computes the gamma matrix for a 5/7 RSCC over AWGN using BPSK.
%   		GAMMA = GAMMA_CALC(y,E,EbN0_dB)
%   		y is channle output, E is symbol energy, and EbN0_dB is SNR/bit (in dB).

M = length(y);              % Length of channel output
N = M/2;                    % Depth of Trellis
Ns=4;                       % Numner of states
y_s = y(1:2:M-1);           % Outputs corresponding to systematic bits
y_p = y(2:2:M);             % Outputs corresponding to parity-check bits
[c_s c_p] = RSCC_5_7(N);    % Generation of the 5/7 RSCC trellis
Eb = 2*E;
N0 = Eb*10^(-EbN0_dB/10);   % Noise variance
gamma = zeros(Ns^2,N);      % Initialization of gamma
for i = 1 : N               % Time index
    gamma(1,i) = 1/(2*pi*N0)*exp(-(y_s(i)^2+y_p(i)^2+2*E)/N0)...
        *exp((2*(y_s(i)*c_s(1,i)+y_p(i)*c_p(1,i)))/N0);
    gamma(3,i) = 1/(2*pi*N0)*exp(-(y_s(i)^2+y_p(i)^2+2*E)/N0)...
        *exp((2*(y_s(i)*c_s(3,i)+y_p(i)*c_p(3,i)))/N0);
    if i > 1
        gamma(10,i) = 1/(2*pi*N0)*exp(-(y_s(i)^2+y_p(i)^2+2*E)/N0)...
            *exp((2*(y_s(i)*c_s(10,i)+y_p(i)*c_p(10,i)))/N0);
        gamma(12,i) = 1/(2*pi*N0)*exp(-(y_s(i)^2+y_p(i)^2+2*E)/N0)...
            *exp((2*(y_s(i)*c_s(12,i)+y_p(i)*c_p(12,i)))/N0);
        if i > 2
            gamma(5,i) = 1/(2*pi*N0)*exp(-(y_s(i)^2+y_p(i)^2+2*E)/N0)...
                *exp((2*(y_s(i)*c_s(5,i)+y_p(i)*c_p(5,i)))/N0);
            gamma(7,i) = 1/(2*pi*N0)*exp(-(y_s(i)^2+y_p(i)^2+2*E)/N0)...
                *exp((2*(y_s(i)*c_s(7,i)+y_p(i)*c_p(7,i)))/N0);
            gamma(14,i) = 1/(2*pi*N0)*exp(-(y_s(i)^2+y_p(i)^2+2*E)/N0)...
                *exp((2*(y_s(i)*c_s(14,i)+y_p(i)*c_p(14,i)))/N0);
            gamma(16,i) = 1/(2*pi*N0)*exp(-(y_s(i)^2+y_p(i)^2+2*E)/N0)...
                *exp((2*(y_s(i)*c_s(16,i)+y_p(i)*c_p(16,i)))/N0);
        end
    end
end