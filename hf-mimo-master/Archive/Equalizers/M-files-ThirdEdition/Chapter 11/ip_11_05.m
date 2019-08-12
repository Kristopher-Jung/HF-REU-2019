% MATLAB script for Illustrative Problem 11.5
echo on;
H_simo = [1 0.5]';          % Channel realization
H_miso = [1 0.5];           % Channel realization
Nt_miso = 2;                % No. of transmit antennas
Nr_simo = 2;                % No. of receive antennas
SNR_dB = 0:0.01:20;         % SNR in dB
SNR = power(10,SNR_dB/10);
% Capacity calculations:
C_simo = log2(1 + SNR*sum(H_simo.^2));
C_miso = log2(1 + SNR*sum(H_miso.^2)/Nt_miso);
% Plot the results:
plot(SNR_dB,C_simo,'-.',SNR_dB,C_miso)
axis([0 20 0 15])
xlabel('Average SNR (dB)','fontsize',10)
ylabel('Capacity (bps/Hz)','fontsize',10)
legend('SIMO','MISO')
