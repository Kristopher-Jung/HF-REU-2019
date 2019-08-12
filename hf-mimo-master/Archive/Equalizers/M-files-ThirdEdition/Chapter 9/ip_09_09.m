% MATLAB script for Illustrative Problem 9.9

D = 2;
sigma = 1;
Eb = 1/sqrt(2);
EbNo_rx_per_ch_dB = 5:5:30;    
EbNo_rx_per_ch = 10.^(EbNo_rx_per_ch_dB/10);
No = Eb*2*sigma^2*10.^(-EbNo_rx_per_ch_dB/10);
BER = zeros(1,length(No));     
SNR_rx_per_b_per_ch = zeros(1,length(No));
% Calculation of error probability using Monte Carlo simulation:
for i = 1:length(No)
    no_bits = 0;               
    no_errors = 0;
    P_rx_t = 0;                % Total rxd power
    P_n_t = 0;                 % Total noise power
    r = zeros(2,2);            
    R = zeros(1,2);
    % Assumption: m = 1 (All one codeword is transmitted):
    while no_errors <= 100
        no_bits = no_bits + 1;
        u = rand(1,2); alpha = sigma*sqrt(-2*log(u)); phi = 2*pi*rand(1,2);        
        noise = sqrt(No(i)/2)*(randn(2,2) + 1i*randn(2,2));
        r(1,1) = alpha(1)*sqrt(Eb)*exp(1i*phi(1))+noise(1,1);
        r(1,2) = noise(1,2);
        r(2,1) = alpha(2)*sqrt(Eb)*exp(1i*phi(2))+noise(2,1);
        r(2,2) = noise(2,2);
        R(1) = abs(r(1,1))^2 + abs(r(2,1))^2;
        R(2) = abs(r(1,2))^2 + abs(r(2,2))^2;
        if R(1) <= R(2)
            m_h = 0;
        else
            m_h = 1;
        end
        P_n_t = P_n_t + No(i);
        P_rx_t = P_rx_t + 0.5*(abs(r(1))^2 + abs(r(2))^2);
        no_errors = no_errors + (1-m_h);
    end
    SNR_rx_per_b_per_ch(i) = (P_rx_t-P_n_t)/P_n_t;
    BER(i) = no_errors/no_bits;
    echo off
end
echo on
% Calculation of error probability using the theoretical formula:
rho = EbNo_rx_per_ch; 
rho_dB = 10*log10(rho);
rho_b =D*rho;                  
rho_b_dB = 10*log10(rho_b);
K_D = factorial((2*D-1))/factorial(D)/factorial((D-1));
P_2 = K_D./rho.^D;
% Plot the results:
semilogy(rho_b_dB,BER,'-*',rho_b_dB,P_2,'-o')
xlabel('Average SNR/bit (dB)'); ylabel('BER')
legend('Monte Carlo simulation','Theoretical value')