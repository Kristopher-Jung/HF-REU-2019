% MATLAB script for Illustrative Problem 11.1

Nt = 2;                         % No. of transmit antennas
Nr = 2;                         % No. of receive antennas
No = 1;                         % Noise variance
s = 2*randi([0 1],Nt,1) - 1;    % Binary transmitted symbols
H = (randn(Nr,Nt) + 1i*randn(Nr,Nt))/sqrt(2);       % Channel coefficients
noise = sqrt(No/2)*(randn(Nr,1) + 1i*randn(Nr,1));  % AWGN noise
y = H*s + noise;                % Inputs to the detectors
disp(['The inputs to the detectors are:     ', num2str(y')])