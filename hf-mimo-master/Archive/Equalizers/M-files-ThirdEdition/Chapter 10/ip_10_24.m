% MATLAB script for Illustrative Problem 10.24

H = [1 0 1 1 1 0 0
     1 1 0 1 0 1 0
     0 1 1 1 0 0 1];            % Code parity-check matrix
E = 1;                          % Symbol energy
n = size(H,2);                  % Codeword length
f = size(H,1);                  % Number of parity check bits
R = (n-f)/n;                    % Code rate
EbN0_dB = 2;
EbN0 = 10^(EbN0_dB/10);
noise_variance = E/(2*R*EbN0);              
noise = sqrt(noise_variance)*randn(1,n);
y = ones(1,n) + noise;        % Assuming the all-zero codeword is transmitted
max_it = 50;
[c check] = sp_decoder(H,y,max_it,E,EbN0_dB);