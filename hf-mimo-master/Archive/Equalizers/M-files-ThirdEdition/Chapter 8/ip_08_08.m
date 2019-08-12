% MATLAB script for Illustrative Problem 8.8
clear;
T = 1;
Fs = 200;
t = 0 : 1/(Fs*T) : T-1/(Fs*T);
K = 32;
k = 1 : K-1;
rlz = 20;                           % No. of realizations
PAR = zeros(1,rlz);                 % Initialization for speed
echo off;
for j = 1 : rlz
    theta = pi*floor(rand(1,length(k))/0.25)/2;
    phi = 2*pi*rand(4,length(k));
    PAR_phi = zeros(1,size(phi,1)); % Initialization for speed
    for m = 1 : size(phi,1) 
        x = zeros(1,Fs);            % Initialization for speed
        for i = 1 : Fs
            for l = 1 : K-1
                x(i) = x(i) + cos(2*pi*l*t(i)/T+theta(l)+phi(m,l));
            end
        end
        % Calculation of the PAR:
        P_peak = max(x.^2);
        P_av = sum(x.^2)/Fs;
        PAR_phi(m) = P_peak/P_av;
    end
    [PAR(j) idx_theta]= min(PAR_phi);
end
echo on;
% Plotting the results:
stem(PAR)
axis ([1 20 min(PAR) max(PAR)])
xlabel('Realization')
ylabel('PAR')