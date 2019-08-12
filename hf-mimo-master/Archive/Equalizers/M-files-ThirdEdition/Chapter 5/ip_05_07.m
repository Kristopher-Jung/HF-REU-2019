% MATLAB script for Illustrative Problem 5.7

% Initialization:
K=20;           % Number of samples
A=1;            % Signal amplitude
l=0:K;
s_0=A*ones(1,K);% Signal waveform
r_0=zeros(1,K); % Output signal

% Case 1: noise~N(0,0)
    noise=random('Normal',0,0,1,K);
    % Sub-case s = s_0:
    s=s_0;
    r=s+noise;  % received signal  
    for n=1:K
        r_0(n)=sum(r(1:n).*s_0(1:n));
    end
    % Plotting the results:
    subplot(3,2,1)
    plot(l,[0 r_0])
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb'})
    axis([0 20 0 25])
    xlabel('(a) \sigma^2= 0 & S_{0} is transmitted ','fontsize',10)
%     text(15,3,'\fontsize{10} r_{0}: - & r_{1}: --','hor','left')
    % Sub-case s = s_1:
    s=-s_0;
    r=s+noise;  % received signal
    for n=1:K
        r_0(n)=sum(r(1:n).*s_0(1:n));
    end
    % Plotting the results:
    subplot(3,2,2)
    plot(l,[0 r_0])
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb'})
    axis([0 20 -25 0])
    xlabel('(b) \sigma^2= 0 & S_{1} is transmitted ','fontsize',10)
% Case 2: noise~N(0,0.1)
    noise=random('Normal',0,0.1,1,K);
    % Sub-case s = s_0:
    s=s_0;
    r=s+noise;  % received signal
    for n=1:K
        r_0(n)=sum(r(1:n).*s_0(1:n));
    end
    % Plotting the results:
    subplot(3,2,3)
    plot(l,[0 r_0])
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb'})
    axis([0 20 0 25])
    xlabel('(c) \sigma^2= 0.1 & S_{0} is transmitted ','fontsize',10)
    % Sub-case s = s_1:
    s=-s_0;
    r=s+noise;  % received signal
    for n=1:K
        r_0(n)=sum(r(1:n).*s_0(1:n));
    end
    % Plotting the results:
    subplot(3,2,4)
    plot(l,[0 r_0])
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb'})
    axis([0 20 -25 0])
    xlabel('(d) \sigma^2= 0.1 & S_{1} is transmitted ','fontsize',10)
% Case 3: noise~N(0,1)
    noise=random('Normal',0,1,1,K);
    % Sub-case s = s_0:
    s=s_0;
    r=s+noise;  % received signal
    for n=1:K
        r_0(n)=sum(r(1:n).*s_0(1:n));
    end
    % Plotting the results:
    subplot(3,2,5)
    plot(l,[0 r_0])
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb'})
    axis([0 20 -5 25])
    xlabel('(e) \sigma^2= 1 & S_{0} is transmitted ','fontsize',10)
    % Sub-case s = s_1:
    s=-s_0;
    r=s+noise;  % received signal
    for n=1:K
        r_0(n)=sum(r(1:n).*s_0(1:n));
    end
    % Plotting the results:
    subplot(3,2,6)
    plot(l,[0 r_0])
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb'})
    axis([0 20 -25 5])
    xlabel('(f) \sigma^2= 1 & S_{1} is transmitted ','fontsize',10)