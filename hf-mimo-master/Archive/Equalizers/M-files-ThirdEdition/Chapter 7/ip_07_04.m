% MATLAB script for Illustrative Problem 7.4

M = 4;
Es = 1;                                 % Energy per symbol
T = 1;
Ts = 100/T;
fc = 30/T;
t = 0:T/100:T;
l_t = length(t);
g_T = sqrt(2/T)*ones(1,l_t);
si_1 = g_T.*cos(2*pi*fc*t);
si_2 = -g_T.*sin(2*pi*fc*t);
var = [ 0 0.05 0.5];                % Noise variance vector
k = 1;
% Generation of the noise components:
n_c = sqrt(var(k))*randn(1,l_t);
n_s = sqrt(var(k))*randn(1,l_t);
for m = 0:M-1
    % Generation of the transmitted signal:
    s_mc = sqrt(Es) * cos(2*pi*m/M);
    s_ms = sqrt(Es) * sin(2*pi*m/M);
    u_m = s_mc.*si_1 + s_ms.*si_2;
    % The received signal:
    r = u_m + n_c.*cos(2*pi*fc*t) - n_s.*sin(2*pi*fc*t);
    % The correlator outputs:
    y_c = zeros(1,l_t);
    y_s = zeros(1,l_t);
    for i = 1:l_t
        y_c(i) = sum(r(1:i).*si_1(1:i));
        y_s(i) = sum(r(1:i).*si_2(1:i));
        echo off
    end
    echo on
    % Plotting the results:
    subplot(3,2,m+1)
    plot([0 1:length(y_c)-1],y_c,'.-')
    hold
    plot([0 1:length(y_s)-1],y_s)
    if m==0
        title(['\sigma^2 = ',num2str(var(k)),', \Phi = 0^{\circ}'])
        ylabel('\it{y_c(n)}')
    elseif m==1
        title(['\sigma^2 = ',num2str(var(k)),', \Phi = 90^{\circ}'])
        ylabel('\it{y_s(n)}')
    elseif m==2
        title(['\sigma^2 = ',num2str(var(k)),', \Phi = 180^{\circ}'])
        ylabel('\it{y_c(n)}')
    else
        title(['\sigma^2 = ',num2str(var(k)),', \Phi = 270^{\circ}'])
        ylabel('\it{y_s(n)}')
    end
    xlabel('\it{n}')
    axis auto
    echo off
end
echo on
k = 2;
for m = 0:M-1
    % Generation of the transmitted signal:
    s_mc = sqrt(Es) * cos(2*pi*m/M);
    s_ms = sqrt(Es) * sin(2*pi*m/M);
    u_m = s_mc.*si_1 + s_ms.*si_2;
    % The received signal:
    r = u_m + n_c.*cos(2*pi*fc*t) - n_s.*sin(2*pi*fc*t);
    % The correlator outputs:
    y_c = zeros(1,l_t);
    y_s = zeros(1,l_t);
    for i = 1:l_t
        y_c(i) = sum(r(1:i).*si_1(1:i));
        y_s(i) = sum(r(1:i).*si_2(1:i));
        echo off
    end
    echo on
    % Plotting the results:
    if m>=2
        if m==2
            figure
        end
        subplot(3,2,m-1)
        plot([0 1:length(y_c)-1],y_c,'.-')
        hold
        plot([0 1:length(y_s)-1],y_s)
    if m==0
        title(['\sigma^2 = ',num2str(var(k)),', \Phi = 0^{\circ}'])
        ylabel('\it{y_c(n)}')
    elseif m==1
        title(['\sigma^2 = ',num2str(var(k)),', \Phi = 90^{\circ}'])
        ylabel('\it{y_s(n)}')
    elseif m==2
        title(['\sigma^2 = ',num2str(var(k)),', \Phi = 180^{\circ}'])
        ylabel('\it{y_c(n)}')
    else
        title(['\sigma^2 = ',num2str(var(k)),', \Phi = 270^{\circ}'])
        ylabel('\it{y_s(n)}')
    end
        xlabel('\it{n}')
        axis auto
    else
        subplot(3,2,2*k+1+m)
        plot([0 1:length(y_c)-1],y_c,'.-')
        hold
        plot([0 1:length(y_s)-1],y_s)
    if m==0
        title(['\sigma^2 = ',num2str(var(k)),', \Phi = 0^{\circ}'])
        ylabel('\it{y_c(n)}')
    elseif m==1
        title(['\sigma^2 = ',num2str(var(k)),', \Phi = 90^{\circ}'])
        ylabel('\it{y_s(n)}')
    elseif m==2
        title(['\sigma^2 = ',num2str(var(k)),', \Phi = 180^{\circ}'])
        ylabel('\it{y_c(n)}')
    else
        title(['\sigma^2 = ',num2str(var(k)),', \Phi = 270^{\circ}'])
        ylabel('\it{y_s(n)}')
    end
        xlabel('\it{n}')
        axis auto
    end
    echo off
end
echo on
k = 3;
for m = 0:M-1
    % Generation of the transmitted signal:
    s_mc = sqrt(Es) * cos(2*pi*m/M);
    s_ms = sqrt(Es) * sin(2*pi*m/M);
    u_m = s_mc.*si_1 + s_ms.*si_2;
    % The received signal:
    r = u_m + n_c.*cos(2*pi*fc*t) - n_s.*sin(2*pi*fc*t);
    % The correlator outputs:
    y_c = zeros(1,l_t);
    y_s = zeros(1,l_t);
    for i = 1:l_t
        y_c(i) = sum(r(1:i).*si_1(1:i));
        y_s(i) = sum(r(1:i).*si_2(1:i));
        echo off
    end
    echo on
    % Plotting the results:
    subplot(3,2,k+m)
    plot([0 1:length(y_c)-1],y_c,'.-')
    hold
    plot([0 1:length(y_s)-1],y_s)
    if m==0
        title(['\sigma^2 = ',num2str(var(k)),', \Phi = 0^{\circ}'])
        ylabel('\it{y_c(n)}')
    elseif m==1
        title(['\sigma^2 = ',num2str(var(k)),', \Phi = 90^{\circ}'])
        ylabel('\it{y_s(n)}')
    elseif m==2
        title(['\sigma^2 = ',num2str(var(k)),', \Phi = 180^{\circ}'])
        ylabel('\it{y_c(n)}')
    else
        title(['\sigma^2 = ',num2str(var(k)),', \Phi = 270^{\circ}'])
        ylabel('\it{y_s(n)}')
    end
    xlabel('\it{n}')
    axis auto
    echo off
end