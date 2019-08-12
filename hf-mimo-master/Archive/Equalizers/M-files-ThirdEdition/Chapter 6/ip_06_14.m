% MATLAB script for Illustrative Problem 6.14

N=20000;                       % Length of the training sequence
% Number of transmitted symbols for each choice of SNR
Nt=[1000000 1000000 1000000 1000000 1000000 5000000 10000000];
delta=0.0045;
K=5;
actual_isi=[0.05 -0.063 0.088 -0.126 -0.25 0.9047 0.25 0 0.126 0.038 0.088];
SNR_dB=2:2:14;
SNR=10.^(SNR_dB/10);
l_SNR=size(SNR,2);
var=1/2./SNR;
sigma=sqrt(var);
Pe=zeros(1,l_SNR);
for idx=1:l_SNR
    % (A) The training sequence:
    training_s=ones(1,N);
    for i=1:N
        if (rand<0.5)
            training_s(i)=-1;
        end
        echo off
    end
    echo on
    % The channel output:
    y=filter(actual_isi,1,training_s);
    noise=zeros(1,N);
    for i=1:2:N
        noise(i) =random('Normal',0,sigma(idx));
        noise(i+1) = noise(i);
        echo off
    end
    echo on
    y=y+noise;
    % The equalization part follows:
    estimated_c=[0 0 0 0 0 1 0 0 0 0 0]; % initial estimate of ISI
    for k=1:N-2*K
        y_k=y(k:k+2*K);
        z_k=estimated_c*y_k';
        e_k=training_s(k)-z_k;
        estimated_c=estimated_c+delta*e_k*y_k;
        echo off
    end
    echo on
    % (B) The transmitted information sequence:
    info=ones(1,Nt(idx));
    for i=1:Nt(idx)
        if (rand<0.5)
            info(i)=-1;
        end
        echo off
    end
    echo on
    % The channel output:
    y=filter(actual_isi,1,info);
    noise=sigma(idx)*randn(1,Nt(idx));
    y=y+noise;
    % The equalization part:
    count = 0;
    err_count=0;
    z_k_vec=ones(1,Nt(idx)-2*K);
    for k=1:Nt(idx)-2*K;
        y_k=y(k:k+2*K);
        z_k=estimated_c*y_k';
        if z_k<0
            z_k_vec(k)=-1;
        end
        err_count=err_count+0.5*abs(info(k)-z_k_vec(k));
        echo off
    end
    echo on
    Pe(idx)= err_count/length(z_k_vec);
    clear y; clear noise
    echo off
end
echo on
% Plot the results:
semilogy(SNR_dB,Pe)
grid
ylabel('P_e')
xlabel('SNR (dB)')