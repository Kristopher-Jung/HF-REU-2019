% MATLAB script for Illustrative Problem 11.7

SNR_dB = 0:5:20; SNR = 10.^(SNR_dB/10);
L = length(SNR);
% Initialization:
C1 = zeros(1,L); C2 = zeros(1,L); C3 = zeros(1,L);
% Capacity Calculations:
echo off;
for i = 1:L
    % Nt = Nr = N = 1:
    C1(i) = quadgk(@(x)log2(1 + SNR(i)*x).*exp(-x),0,inf);
    % Nt = Nr = N = 2:
    C2(i) = quad2d(@(x,y)(log2(1 + SNR(i)*x/2)+log2(1 + SNR(i)*y/2))/2.*...
        exp(-x-y).*(x-y).^2,0,1000,0,1000);
    % Nt = Nr = N = 3:
    C3(i) = triplequad(@(x,y,z)(log2(1 + SNR(i)*x/3)+log2(1 + SNR(i)*y/3)+log2(1 + SNR(i)*z/3))/...
        24.*exp(-x-y-z).*((x-y).*(x-z).*(y-z)).^2,0,10,0,10,0,10);
end
echo on;
% Plot the results:
plot(SNR_dB,C1,'-*',SNR_dB,C2,'-o',SNR_dB,C3,'-s')
axis([0 20 0 25])
legend('N_T=1,N_R=1','N_T=2,N_R=2','N_T=3,N_R=3',2)
xlabel('Average SNR (dB)','fontsize',10)
ylabel('Capacity (bps/Hz)','fontsize',10)