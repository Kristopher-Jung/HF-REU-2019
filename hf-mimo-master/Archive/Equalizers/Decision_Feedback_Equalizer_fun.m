function y= Decision_Feedback_Equalizer_fun(N,Nt, K,delta, N1, N2, actual_isi, SNR_dB)
% M ATLAB script for Illustrative Problem 6.15 

%Decision Feedback Equalizer
%This is a non-linear equalizer, it will perform better under high
%amplitudal noise, but is more computationally complex

%Experimental testing shows a small improvement over linear equalizer under
%our setup. This can be improved by adjusting parameters, but still not
%nearly good enough. 

% N=20000;                       % Length of the training sequence
% % Number of transmitted symbols for each choice of SNR
% Nt=[1000000 1000000 1000000 1000000 1000000 5000000 10000000];
% delta=0.0045;
% K=5;
% N1=3;N2=2;
% actual_isi=[0.407 0.815 0.407];
% SNR_dB=2:2:14;
% SNR=10.^(SNR_dB/10);
l_SNR=length(SNR);
var=1/2./SNR;
sigma=sqrt(var);        % Standard deviation
Pe_mse=zeros(1,l_SNR); Pe_dfe=zeros(1,l_SNR);
for idx=1:l_SNR
    % (A) The training sequence:
    training_s_mse=ones(1,N);
    training_s_dfe=ones(1,N);
    for i=1:N
        if (rand<0.5)
            training_s_mse(i)=-1;
            echo off
        end
    end
    echo on
    for i=1:N
        if (rand<0.5)
            training_s_dfe(i)=-1;
            echo off
        end
    end
    echo on
    % The channel output:
    y_mse=filter(actual_isi,1,training_s_mse);
    y_dfe=filter(actual_isi,1,training_s_dfe);
    noise_mse=sigma(idx)*randn(1,N);
    noise_dfe=sigma(idx)*randn(1,N);
    y_mse=y_mse+noise_mse;
    y_dfe=y_dfe+noise_dfe;
    % The equalization for the mse equalizer:
    estimated_c_mse=[0 0 0 0 0 1 0 0 0 0 0]; % Initial estimate of ISI
    for k=1:N-2*K
        y_k_mse=y_mse(k:k+2*K);
        z_k_mse=estimated_c_mse*y_k_mse';
        e_k_mse=training_s_mse(k)-z_k_mse;
        estimated_c_mse=estimated_c_mse+delta*e_k_mse*y_k_mse;
        echo off
    end
    echo on
    % Training the feedforward and feedback filters for the dfe equalizer:
    estimated_c_dfe=[0 1 0 ];   % initial estimate of ISI
    estimated_b_dfe=[0 1];       % Initial estimate of ISI
    a_tilda_dfe=ones(1,N-(N1-1));
    for k=1:N-(N1-1)
        y_k_dfe=y_dfe(k:k+N1-1);
        z_k_ff_dfe=estimated_c_dfe*y_k_dfe';
        if k==1
            a_tilda_k_dfe=[0 0];
        elseif k==2
            a_tilda_k_dfe=[0 a_tilda_dfe(1)];
        else
            a_tilda_k_dfe=a_tilda_dfe(k-N2:k-1);
        end
        z_k_fb_dfe=estimated_b_dfe*a_tilda_k_dfe';
        z_k_dfe=z_k_ff_dfe-z_k_fb_dfe;
        if z_k_dfe<0
            a_tilda_dfe(k)=-1;
        end
        e_k_dfe=training_s_dfe(k)-z_k_dfe;
        estimated_c_dfe=estimated_c_dfe+delta*e_k_dfe*y_k_dfe;
        estimated_b_dfe=estimated_b_dfe-delta*e_k_dfe*a_tilda_k_dfe;
        echo off
    end
    echo on
    % (B) The transmitted information sequence:
    info_mse=ones(1,Nt(idx));
    info_dfe=ones(1,Nt(idx));
    for i=1:Nt(idx)
        if (rand<0.5)
            info_mse(i)=-1;
        end
        echo off
    end
    for i=1:Nt(idx)
        if (rand<0.5)
            info_dfe(i)=-1;
        end
    end
    echo on
    % The channel output:
    y_mse=filter(actual_isi,1,info_mse);
    y_dfe=filter(actual_isi,1,info_dfe);
    noise_mse=sigma(idx)*randn(1,Nt(idx));
    noise_dfe=sigma(idx)*randn(1,Nt(idx));
    y_mse=y_mse+noise_mse;
    y_dfe=y_dfe+noise_dfe;
    % The equalization part:
    count_mse = 0;
    count_dfe = 0;
    err_count_mse=0;
    err_count_dfe=0;
    z_k_mse_vec=ones(1,Nt(idx)-2*K);
    z_k_vec_dfe=zeros(1,Nt(idx)-(N1-1));
    a_tilda_dfe=ones(1,Nt(idx)-(N1-1));
    for k=1:Nt(idx)-2*K;
        y_k_mse=y_mse(k:k+2*K);
        z_k_mse=estimated_c_mse*y_k_mse';
        if z_k_mse<0
            z_k_mse_vec(k)=-1;
        end
        err_count_mse=err_count_mse+0.5*abs(info_mse(k)-z_k_mse_vec(k));
        echo off
    end
    echo on
    Pe_mse(idx)= err_count_mse/length(z_k_mse_vec);
    for k=1:Nt(idx)-(N1-1);
        y_k_dfe=y_dfe(k:k+N1-1);
        z_k_ff_dfe=estimated_c_dfe*y_k_dfe';
        if k==1
            a_tilda_k_dfe=[0 0];
        elseif k==2
            a_tilda_k_dfe=[0 a_tilda_dfe(1)];
        else
            a_tilda_k_dfe=a_tilda_dfe(k-N2:k-1);
        end
        z_k_fb_dfe=estimated_b_dfe*a_tilda_k_dfe';
        z_k_dfe=z_k_ff_dfe-z_k_fb_dfe;
        if z_k_dfe<0
            a_tilda_dfe(k)=-1;
        end
        count_dfe=count_dfe+1;
        z_k_vec_dfe(count_dfe)=a_tilda_dfe(k);
        err_count_dfe=err_count_dfe+0.5*abs(info_dfe(k)-a_tilda_dfe(k));
        echo off
    end
    echo on
    Pe_dfe(idx)= err_count_dfe/length(z_k_vec_dfe);
    clear y; clear noise_mse
    clear y_dfe; clear noise_dfe
end
% Plot the results:
semilogy(SNR_dB,Pe_mse,SNR_dB,Pe_dfe,'--')
legend('Linear MSE','DFE')
ylabel('P_e')
xlabel('SNR (dB)')
end