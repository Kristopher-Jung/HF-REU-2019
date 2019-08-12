% MATLAB script for Illustrative Problem 11.4

Nt = 2;                     % No. of transmit antennas
H = [1 0.5; 0.4 0.8];       % Channel realization
lamda = eig(H*H');          % Eigenvalue calculation
SNR_dB = 0:0.01:20;         % SNR in dB
SNR = power(10,SNR_dB/10);  
% Capacity calculation:
C = log2(1 + SNR*lamda(1)/Nt) + log2(1 + SNR*lamda(2)/Nt);
disp(['The eigenvales are:   ', num2str(lamda')]);
% Plot the results:
plot(SNR_dB,C)
axis([0 20 0 15])
xlabel('Average SNR (dB)','fontsize',10)
ylabel('Capacity (bps/Hz)','fontsize',10)