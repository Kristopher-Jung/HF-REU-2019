function [detect phase_d] = dd_dpsk(r,M,mapping)

T = 1;
fc = 30/T;
t = T/100:T/100:2*T;
l_t = length(t);
g_T = sqrt(2/T)*ones(1,l_t);
si_1 = g_T.*cos(2*pi*fc*t);
si_2 = -g_T.*sin(2*pi*fc*t);
% Outputs of the correlators:
x_I_1 = sum(r(1:l_t/2).*si_1(1:l_t/2));
x_Q_1 = sum(r(1:l_t/2).*si_2(1:l_t/2));
x_I_2 = sum(r(l_t/2+1:l_t).*si_1(l_t/2+1:l_t));
x_Q_2 = sum(r(l_t/2+1:l_t).*si_2(l_t/2+1:l_t));
% Determining the phases of the received symbols:
theta_1 = atan(x_Q_1/x_I_1);
if x_I_1 < 0 && x_Q_1 > 0
    theta_1 = pi + theta_1;
end
if x_I_1 < 0 && x_Q_1 < 0
    theta_1 = pi + theta_1;
end
theta_2 = atan(x_Q_2/x_I_2);
if x_I_2 < 0 && x_Q_2 > 0
    theta_2 = pi + theta_2;
end
if x_I_2 < 0 && x_Q_2 < 0
    theta_2 = pi + theta_2;
end
delta_theta = theta_2 - theta_1;
% Detection of the mapped symbol and differential phase:
idx = mod(abs(round(delta_theta/2/pi*M)),M);
detect = mapping(1+idx);
phase_d = idx*2*pi/M;