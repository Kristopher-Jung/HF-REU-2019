% MATLAB script for Illustrative Problem 5.9

% Initialization:
K=30;           % Number of samples
A=1;            % Signal amplitude
l=0:K;
s=A*ones(1,K);  % Signal waveform
y=zeros(1,K);   % Output signal

% Case1: noise~N(0,0)
    noise=random('Normal',0,0,1,K);
    % Sub-case: 0 is transmitted
    r=noise;    % received signal    
    for n=1:K
        y(n)=sum(r(1:n).*s(1:n));
    end
    % Plotting the results:
    subplot(3,2,1)
    plot(l,[0 y])
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb','25Tb','30Tb'})
    axis([0 30 -1 1])
    xlabel('(a) \sigma^2= 0 & 0 is transmitted' ,'fontsize',10)
    % Sub-case: 1 is transmitted
    r=s+noise;  % received signal
    for n=1:K
        y(n)=sum(r(1:n).*s(1:n));
    end
    % Plotting the results:
    subplot(3,2,2)
    plot(l,[0 y])
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb','25Tb','30Tb'})
    axis([0 30 0 40])
    xlabel('(b) \sigma^2= 0 & 1 is transmitted' ,'fontsize',10)
    % Case2: noise~N(0,0.1)
    noise=random('Normal',0,0.1,1,K);
    % Sub-case: 0 is transmitted
    r=noise;    % received signal
    for n=1:K
        y(n)=sum(r(1:n).*s(1:n));
    end
    % Plotting the results:
    subplot(3,2,3)
    plot(l,[0 y])
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb','25Tb','30Tb'})
    axis([0 30 -1 1])
    xlabel('(c) \sigma^2= 0.1 & 0 is transmitted' ,'fontsize',10)
    % Sub-case: 1 is transmitted
    r=s+noise;  % received signal
    for n=1:K
        y(n)=sum(r(1:n).*s(1:n));
    end
    % Plotting the results:
    subplot(3,2,4)
    plot(l,[0 y])
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb','25Tb','30Tb'})
    axis([0 30 0 40])
    xlabel('(d) \sigma^2= 0.1 & 1 is transmitted' ,'fontsize',10)
% Case3: noise~N(0,1)
    noise=random('Normal',0,1,1,K);
    % Sub-case: 0 is transmitted
    r=noise;    % received signal
    for n=1:K
        y(n)=sum(r(1:n).*s(1:n));
    end
    % Plotting the results:
    subplot(3,2,5)
    plot(l,[0 y])
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb','25Tb','30Tb'})
    axis([0 30 -10 10])
    xlabel('(e) \sigma^2= 1 & 0 is transmitted' ,'fontsize',10)
    % Sub-case: 1 is transmitted
    r=s+noise;  % received signal
    for n=1:K
        y(n)=sum(r(1:n).*s(1:n));
    end
    % Plotting the results:
    subplot(3,2,6)
    plot(l,[0 y])
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb','25Tb','30Tb'})
    axis([0 30 0 40])
    xlabel('(f) \sigma^2= 1 & 1 is transmitted' ,'fontsize',10)