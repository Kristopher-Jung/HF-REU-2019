% MATLAB script for Illustrative Problem 9.8

Eb = 1;                                 % Energy per bit
EbNo_dB = 0:5:35;
EbNo = 10.^(EbNo_dB/10);
No_over_2 = Eb*10.^(-EbNo_dB/10);       % Noise power
sigma = 1;                              % Rayleigh parameter
BER = zeros(1,length(EbNo));
% Calculation of error probability using Monte Carlo simulation:
for i = 1:length(EbNo)
    no_errors = 0;
    no_bits = 0;
    % Assumption: m = 0 (All zero codeword is transmitted):
    while no_errors <= 100
        no_bits = no_bits + 1;
        u = rand;        
        alpha = sigma*sqrt(-2*log(u));
        noise = sqrt(No_over_2(i))*randn(1,2);
        r(1) = alpha*sqrt(Eb) + noise(1);
        r(2) = noise(2);
        if r(1) >= r(2)
            r_d = 0;
        else
            r_d = 1;
        end
        no_errors = no_errors + r_d;
    end
    BER(i) = no_errors/no_bits;
    echo off
end
echo on
% Calculation of error probability using the theoretical formula:
rho_b = Eb./No_over_2;
P2 = 1/2*(1-sqrt(rho_b./(2+rho_b)));
% Plot the results:
semilogy(EbNo_dB,BER,'-*',EbNo_dB,P2,'-o')
xlabel('Average SNR/bit (dB)')
ylabel('Error Probability')
legend('Monte Carlo simulation','Theoretical value')