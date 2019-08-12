% MATLAB script for Illustrative Problem 7.7

M = 8;
mapping=[0 1 3 2 7 6 4 5];              % Gray mapping
Es = 1;                                 % Energy per symbol
T = 1;
Ts = 100/T;
fc = 30/T;
t = T/100:T/100:2*T;
l_t = length(t);
g_T = sqrt(2/T)*ones(1,l_t);
si_1 = g_T.*cos(2*pi*fc*t);
si_2 = -g_T.*sin(2*pi*fc*t);
var = 0.05;                             % Noise variance
% Determine the differential phase:
m = 2;                                  % 0 <= m <= 7
theta_d = 2*pi*m/M;
% Assuming the phase of the first txed symbol, i.e., the reference phase is 0:
s_mc1 = sqrt(Es) * 1;
s_ms1 = sqrt(Es) * 0;
u_m1 = s_mc1*si_1(1:l_t/2) + s_ms1*si_2(1:l_t/2);
s_mc2 = sqrt(Es) * cos(theta_d);
s_ms2 = sqrt(Es) * sin(theta_d);
u_m2 = s_mc2*si_1(1:l_t/2) + s_ms2*si_2(1:l_t/2);
% Generation of the noise components:
n_c = sqrt(var)*randn(1,l_t);
n_s = sqrt(var)*randn(1,l_t);
% The received signals:
r1 = u_m1+n_c(1:l_t/2).*cos(2*pi*fc*t(1:l_t/2)) - n_s(1:l_t/2).*sin(2*pi*fc*t(1:l_t/2));
r2 = u_m2+n_c(l_t/2+1:l_t).*cos(2*pi*fc*t(l_t/2+1:l_t)) - n_s(l_t/2+1:l_t).*sin(2*pi*fc*t(l_t/2+1:l_t));
r = [r1 r2];
% Detection of the mapped symbol and differential phase:
[detect phase_d] = dd_dpsk(r,M,mapping);