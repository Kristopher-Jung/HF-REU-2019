% MATLAB script for Illustrative Problem 5.4

% Initialization:
K=20;       % Number of samples
A=1;        % Signal amplitude
l=0:K;
% Defining signal waveforms:
s_0=A*ones(1,K);
s_1=[A*ones(1,K/2) -A*ones(1,K/2)];
% Initializing output signals:
y_0=zeros(1,K);
y_1=zeros(1,K);

% Case 1: noise~N(0,0)
noise=random('Normal',0,0,1,K);
    % Sub-case s = s_0:
    s=s_0;
    y=s+noise;  % received signal
    y_0=conv(y,wrev(s_0));
    y_1=conv(y,wrev(s_1));
    % Plotting the results:
    subplot(3,2,1)
    plot(l,[0 y_0(1:K)],'-k',l,[0 y_1(1:K)],'--k')
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb'})
    axis([0 20 -30 30])
    xlabel('(a) \sigma^2= 0 & S_{0} is transmitted','fontsize',10)
    % Sub-case s = s_1:
    s=s_1;
    y=s+noise;  % received signal
    y_0=conv(y,wrev(s_0));
    y_1=conv(y,wrev(s_1));
    % Plotting the results:
    subplot(3,2,2)
    plot(l,[0 y_0(1:K)],'-k',l,[0 y_1(1:K)],'--k')
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb'})
    axis([0 20 -30 30])
    xlabel('(b) \sigma^2= 0 & S_{1} is transmitted','fontsize',10)
% Case 2: noise~N(0,0.1)
    noise=random('Normal',0,0.1,1,K);
    % Sub-case s = s_0:
    s=s_0;
    y=s+noise;  % received signal
    y_0=conv(y,wrev(s_0));
    y_1=conv(y,wrev(s_1));
    % Plotting the results:
    subplot(3,2,3)
    plot(l,[0 y_0(1:K)],'-k',l,[0 y_1(1:K)],'--k')
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb'})
    axis([0 20 -30 30])
    xlabel('(c) \sigma^2= 0.1 & S_{0} is transmitted','fontsize',10)
    % Sub-case s = s_1:
    s=s_1;
    y=s+noise;  % received signal
    y_0=conv(y,wrev(s_0));
    y_1=conv(y,wrev(s_1));
    % Plotting the results:
    subplot(3,2,4)
    plot(l,[0 y_0(1:K)],'-k',l,[0 y_1(1:K)],'--k')
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb'})
    axis([0 20 -30 30])
    xlabel('(d) \sigma^2= 0.1 & S_{1} is transmitted','fontsize',10)
% Case 3: noise~N(0,1)
    noise=random('Normal',0,1,1,K);
    % Sub-case s = s_0:
    s=s_0;
    y=s+noise;  % received signal
    y_0=conv(y,wrev(s_0));
    y_1=conv(y,wrev(s_1));
    % Plotting the results:
    subplot(3,2,5)
    plot(l,[0 y_0(1:K)],'-k',l,[0 y_1(1:K)],'--k')
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb'})
    axis([0 20 -30 30])
    xlabel('(e) \sigma^2= 1 & S_{0} is transmitted','fontsize',10)
    % Sub-case s = s_1:
    s=s_1;
    y=s+noise;  % received signal
    y_0=conv(y,wrev(s_0));
    y_1=conv(y,wrev(s_1));
    % Plotting the results:
    subplot(3,2,6)
    plot(l,[0 y_0(1:K)],'-k',l,[0 y_1(1:K)],'--k')
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb'})
    axis([0 20 -30 30])
    xlabel('(f) \sigma^2= 1 & S_{1} is transmitted','fontsize',10)