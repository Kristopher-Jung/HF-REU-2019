% MATLAB script for Illustrative Problem 7.2

Am = 1;                                 % Signal Amplitude
T = 1;
Ts = 100/T;
fc = 30/T;
t = 0:T/100:T;
l_t = length(t);
g_T = sqrt(2/T)*ones(1,l_t);
si = g_T .* cos(2*pi*fc*t);
var = [ 0 0.05 0.5];                    % Noise variance vector
for k = 1 : length(var)
    % Generation of the noise components:
    n_c = sqrt(var(k))*randn(1,l_t);
    n_s = sqrt(var(k))*randn(1,l_t);
    noise = n_c.*cos(2*pi*fc*t) - n_s.*sin(2*pi*fc*t);
    r = Am*g_T.*cos(2*pi*fc*t)+noise;   % The received signal    
    y = zeros(1,l_t);
    for i = 1:l_t
        y(i) = sum(r(1:i).*si(1:i));    % The correlator output
    end
    % Plotting the results:
    subplot(3,1,k)
    plot([0 1:length(y)-1],y)
    title(['\sigma^2 = ',num2str(var(k))])
    xlabel('n')
    ylabel('y(nT_s)')
end