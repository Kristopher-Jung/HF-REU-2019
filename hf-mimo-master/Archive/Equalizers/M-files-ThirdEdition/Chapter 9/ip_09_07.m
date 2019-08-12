% MATLAB script for Illustrative Problem 9.7

Eb = 1;                             % Energy per bit
EbNo_dB = 0:5:35;
No_over_2 = Eb*10.^(-EbNo_dB/10);   % Noise power
sigma = 1;                          % Rayleigh parameter
BER = zeros(1,length(EbNo_dB));
% Calculation of error probability using Monte Carlo simulation:
for i = 1:length(EbNo_dB)
    no_errors = 0;
    no_bits = 0;
    % Assumption: m = 0 (All zero codeword is transmitted):
    while no_errors <= 100
        u = rand;
        alpha = sigma*sqrt(-2*log(u));
        noise = sqrt(No_over_2(i))*randn;
        y = alpha*sqrt(Eb) + noise;
        if y <= 0
            y_d = 1;
        else
            y_d = 0;
        end
        no_bits = no_bits + 1;
        no_errors = no_errors + y_d;
    end
    BER(i) = no_errors/no_bits;
    echo off
end
echo on
% Calculation of error probability using the theoretical formula:
rho_b = Eb./No_over_2;
P2 = 1/2*(1-sqrt(rho_b./(1+rho_b)));
% Plot the results:
semilogy(EbNo_dB,BER,'-*',EbNo_dB,P2,'-o')
xlabel('Average SNR/bit (dB)')
ylabel('Error Probability')
legend('Monte Carlo simulation','Theoretical value')