% MATLAB script for Illustrative Problem 9.10

echo on
D = 2;
sigma = 1/sqrt(2);
Eb = 1;
EbNo_rx_per_ch_dB = 5:5:25;
EbNo_rx_per_ch = 10.^(EbNo_rx_per_ch_dB/10);
No = Eb*2*sigma^2*10.^(-EbNo_rx_per_ch_dB/10);
BER = zeros(1,length(No));     
SNR_rx_per_b_per_ch = zeros(1,length(No));
% Calculation of error probability using Monte Carlo simulation:
for i = 1:length(No)
    no_bits = 0;               
    no_errors = 0; 
    % Assumption: m = 0 (All zero codeword is transmitted):
    while no_errors <= 100
        no_bits = no_bits + 1;
        u = rand(1,2); 
        alpha = sigma*sqrt(-2*log(u)); 
        phi = 2*pi*rand(1,2);
        c = alpha.*exp(1i*phi);
        noise = sqrt(No(i)/2)*(randn(1,2) + 1i*randn(1,2));
        r = c*sqrt(Eb) + noise;
        R = real(conj(c(1))*r(1)+conj(c(2))*r(2));
        if R <= 0
            m_h = 1;
        else
            m_h = 0;
        end
        no_errors = no_errors + m_h;
        echo off
    end
    echo on
    BER(i) = no_errors/no_bits;
    echo off
end
echo on
% Calculation of error probability using the theoretical formula:
rho = EbNo_rx_per_ch; 
rho_b = D*rho;                  
rho_b_dB = 10*log10(rho_b);
K_D = factorial((2*D-1))/factorial(D)/factorial((D-1));
P_2 = K_D./(4*rho).^D;
% Plot the results:
semilogy(rho_b_dB,BER,'-*',rho_b_dB,P_2,'-o')
xlabel('Average SNR/bit (dB)'); ylabel('BER')
legend('Monte Carlo simulation','Theoretical value')