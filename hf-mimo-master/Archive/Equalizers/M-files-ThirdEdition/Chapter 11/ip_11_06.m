% MATLAB script for Illustrative Problem 11.6
echo on;
H_simo = [1 0.5]';      % Channel realization
H_miso = [1 0.5];       % Channel realization
Nr_simo = 2;            % No. of receive antennas
Nt_miso = 2;            % No. of transmit antennas
n_simo = Nr_simo;
n_miso = Nt_miso;
SNR_dB = 0:0.01:20;     % SNR in dB
SNR = power(10,SNR_dB/10);
L = size(SNR,2);
% Preallocating for speed:
C_simo = zeros(1,L);
C_miso = zeros(1,L);
% Capacity calculations:
echo off;
for i = 1:L
    C_simo(i) = quadgk(@(x)log2(1 + SNR(i)*x).*power(x,n_simo-1).*exp(-x)/factorial(n_simo-1),0,inf);
    C_miso(i) = quadgk(@(x)log2(1 + SNR(i)*x/Nt_miso).*power(x,n_miso-1).*exp(-x)/factorial(n_miso-1),0,inf);
end
echo on;
% Plotting the results:
plot(SNR_dB,C_simo,'-.',SNR_dB,C_miso)
axis([0 20 0 10])
xlabel('Average SNR (dB)','fontsize',10)
ylabel('Capacity (bps/Hz)','fontsize',10)
legend('SIMO','MISO')