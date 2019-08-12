% MATLAB script for Illustrative Problem 5.15

% Initialization:
K=40;       % Number of samples
A=1;        % Signal amplitude
m=0:K/2;
n=K/2:K;
% Defining signal waveforms:
s_0=[A*ones(1,K/2) zeros(1,K/2)];
s_1=[zeros(1,K/2) A*ones(1,K/2)];
s_2=[-A*ones(1,K/2) zeros(1,K/2)];
s_3=[zeros(1,K/2) -A*ones(1,K/2)];
% Initializing Outputs:
y_0_0=zeros(1,K);
y_0_1=zeros(1,K);
y_0_2=zeros(1,K);
y_0_3=zeros(1,K);
y_1_0=zeros(1,K);
y_1_1=zeros(1,K);
y_1_2=zeros(1,K);
y_1_3=zeros(1,K);

% Case 1: noise~N(0,0)
    noise=random('Normal',0,0,1,K);
    r_0=s_0+noise; r_1=s_1+noise; % received signals
    r_2=s_2+noise; r_3=s_3+noise; % received signals
    for k=1:K/2
        y_0_0(k)=sum(r_0(1:k).*s_0(1:k));
        y_0_1(k)=sum(r_1(1:k).*s_0(1:k));
        y_0_2(k)=sum(r_2(1:k).*s_0(1:k));
        y_0_3(k)=sum(r_3(1:k).*s_0(1:k));
        l=K/2+k;
        y_1_0(l)=sum(r_0(21:l).*s_1(21:l));
        y_1_1(l)=sum(r_1(21:l).*s_1(21:l));
        y_1_2(l)=sum(r_2(21:l).*s_1(21:l));
        y_1_3(l)=sum(r_3(21:l).*s_1(21:l));
    end
    % Plotting the results:
    subplot(3,2,1)
    plot(m,[0 y_0_0(1:K/2)],'-bo',m,[0 y_0_1(1:K/2)],'--b*',...
        m,[0 y_0_2(1:K/2)],':b.',m,[0 y_0_3(1:K/2)],'-.')
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb'})
    axis([0 20 -25 25])
    xlabel('(a) \sigma^2= 0 & y_{0}(kT_{b})' ,'fontsize',10)
    subplot(3,2,2)
    plot(n,[0 y_1_0(K/2+1:K)],'-bo',n,[0 y_1_1(K/2+1:K)],'--b*',...
        n,[0 y_1_2(K/2+1:K)],':b.',n,[0 y_1_3(K/2+1:K)],'-.')
    set(gca,'XTickLabel',{'20Tb','25Tb','30Tb','35Tb','40Tb'})
    axis([20 40 -25 25])
    xlabel('(b) \sigma^2= 0 & y_{1}(kT_{b})' ,'fontsize',10)
    % Case 2: noise~N(0,0.1)
    noise=random('Normal',0,0.1,4,K);
    r_0=s_0+noise(1,:); r_1=s_1+noise(2,:); % received signals    
    r_2=s_2+noise(3,:); r_3=s_3+noise(4,:); % received signals
    for k=1:K/2
        y_0_0(k)=sum(r_0(1:k).*s_0(1:k));
        y_0_1(k)=sum(r_1(1:k).*s_0(1:k));
        y_0_2(k)=sum(r_2(1:k).*s_0(1:k));
        y_0_3(k)=sum(r_3(1:k).*s_0(1:k));
        l=K/2+k;
        y_1_0(l)=sum(r_0(21:l).*s_1(21:l));
        y_1_1(l)=sum(r_1(21:l).*s_1(21:l));
        y_1_2(l)=sum(r_2(21:l).*s_1(21:l));
        y_1_3(l)=sum(r_3(21:l).*s_1(21:l));
    end
    % Plotting the results:
    subplot(3,2,3)
    plot(m,[0 y_0_0(1:K/2)],'-bo',m,[0 y_0_1(1:K/2)],'--b*'...
        ,m,[0 y_0_2(1:K/2)],':b.',m,[0 y_0_3(1:K/2)],'-.')
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb'})
    axis([0 20 -25 25])
    xlabel('(c) \sigma^2= 0.1 & y_{0}(kT_{b})' ,'fontsize',10)
    subplot(3,2,4)
    plot(n,[0 y_1_0(K/2+1:K)],'-bo',n,[0 y_1_1(K/2+1:K)],'--b*',...
        n,[0 y_1_2(K/2+1:K)],':b.',n,[0 y_1_3(K/2+1:K)],'-.')
    set(gca,'XTickLabel',{'20Tb','25Tb','30Tb','35Tb','40Tb'})
    axis([20 40 -25 25])
    xlabel('(d) \sigma^2= 0.1 & y_{1}(kT_{b})' ,'fontsize',10)
    
    % Case 3: noise~N(0,1)
    noise=random('Normal',0,1,4,K);
    r_0=s_0+noise(1,:); r_1=s_1+noise(2,:); % received signals
    r_2=s_2+noise(3,:); r_3=s_3+noise(4,:); % received signals
    for k=1:K/2
        y_0_0(k)=sum(r_0(1:k).*s_0(1:k));
        y_0_1(k)=sum(r_1(1:k).*s_0(1:k));
        y_0_2(k)=sum(r_2(1:k).*s_0(1:k));
        y_0_3(k)=sum(r_3(1:k).*s_0(1:k));
        l=K/2+k;
        y_1_0(l)=sum(r_0(21:l).*s_1(21:l));
        y_1_1(l)=sum(r_1(21:l).*s_1(21:l));
        y_1_2(l)=sum(r_2(21:l).*s_1(21:l));
        y_1_3(l)=sum(r_3(21:l).*s_1(21:l));
    end
    % Plotting the results:
    subplot(3,2,5)
    plot(m,[0 y_0_0(1:K/2)],'-bo',m,[0 y_0_1(1:K/2)],'--b*',...
        m,[0 y_0_2(1:K/2)],':b.',m,[0 y_0_3(1:K/2)],'-.')
    set(gca,'XTickLabel',{'0','5Tb','10Tb','15Tb','20Tb'})
    axis([0 20 -30 30])
    xlabel('(e) \sigma^2= 1 & y_{0}(kT_{b})' ,'fontsize',10)
    subplot(3,2,6)
    plot(n,[0 y_1_0(K/2+1:K)],'-bo',n,[0 y_1_1(K/2+1:K)],'--b*',...
        n,[0 y_1_2(K/2+1:K)],':b.',n,[0 y_1_3(K/2+1:K)],'-.')
    set(gca,'XTickLabel',{'20Tb','25Tb','30Tb','35Tb','40Tb'})
    axis([20 40 -30 30])
    xlabel('(f) \sigma^2= 1 & y_{1}(kT_{b})' ,'fontsize',10)