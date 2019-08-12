% MATLAB script for Illustrative Problem 8.7
clear;
T = 1;
Fs = 200;
t = 0 : 1/(Fs*T) : T-1/(Fs*T);
K = 32;
k = 1 : K-1;
rlz = 20;                   % No. of realizations
% Initialization for speed:
PAR = zeros(1,rlz);
PAR_dB = zeros(1,rlz);
D = zeros(1,rlz);
echo off;
for j = 1 : rlz
    theta = pi*floor(rand(1,length(k))/0.25)/2;
    x = zeros(1,Fs);        % Initialization for speed
    for i = 1 : Fs
        for l = 1 : K-1
            x(i) = x(i) + cos(2*pi*l*t(i)/T+theta(l));
        end
    end
    x_h = x;
    % Calculation of the PAR:
    [P_peak idx] = max(x.^2);
    P_av = sum(x.^2)/Fs;
    PAR(j) = P_peak/P_av;
    PAR_dB(j) = 10*log10(PAR(j));
    % Clipping the peak:
    if P_peak/P_av > 1.9953
        while P_peak/P_av > 1.9953
            x_h(idx) = sqrt(10^0.3*P_av);
            [P_peak idx] = max(x_h.^2);
            P_av = sum(x_h.^2)/Fs;
            PAR_dB(j) = 10*log10(P_peak/P_av);
        end
    end
    D(j) = sum((x-x_h).^2)/Fs;  % Distortion
end
echo on;
% Plotting the results:
stem(D)
axis ([1 20 min(D) max(D)])
xlabel('Realization')
ylabel('Distortion (D)')