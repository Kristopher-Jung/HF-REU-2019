function d_tot = siso_baseline_bpsk
%% Initialize initial data for plots
nTx=1;
nRx=1;
M=2;
ITER=1;
nFwdTaps=10;
nFdbkTaps=3;
step=0.005;
snr_range=[0:5:30];
d_tot=zeros(1,length(snr_range));
d_dfe_lms= zeros(1,length(snr_range));
d_tot_dfe_lms= zeros(1,length(snr_range));
d=zeros(1,length(snr_range));
fd = 1; % Chosen maximum Doppler shift for simulation
window_length=20;
sGauss1 = 0.2;
fGauss1 = -0.5;
Rs=20e4;


dopplerComp1 = doppler('BiGaussian', ...
    'NormalizedStandardDeviations', [sGauss1/fd 1/sqrt(2)], ...
    'NormalizedCenterFrequencies',  [fGauss1/fd 0], ...
    'PowerGains',                   [0.5        0]);
chanComp1 = comm.MIMOChannel( ...
    'SampleRate',          Rs, ...
    'MaximumDopplerShift', fd, ...
    'DopplerSpectrum',     dopplerComp1, ...
    'RandomStream',        'mt19937ar with seed', ...
    'Seed',                99, ...
    'PathGainsOutputPort', true,...
    'NumTransmitAntennas', nTx,...
    'NumReceiveAntennas', nRx,...
     'SpatialCorrelationSpecification', 'None' );
sGauss2 = 0.1;
fGauss2 = 0.4;
dopplerComp2 = doppler('BiGaussian', ...
    'NormalizedStandardDeviations', [sGauss2/fd 1/sqrt(2)], ...
    'NormalizedCenterFrequencies',  [fGauss2/fd 0], ...
    'PowerGains',                   [0.5        0]);
chanComp2 = comm.MIMOChannel( ...
    'SampleRate',          Rs, ...
    'MaximumDopplerShift', fd, ...
    'DopplerSpectrum',     dopplerComp2, ...
    'RandomStream',        'mt19937ar with seed', ...
    'Seed',                999, ...
    'PathGainsOutputPort', true,...
    'NumTransmitAntennas', nTx,...
    'NumReceiveAntennas', nRx,...
    'SpatialCorrelationSpecification', 'None');
gGauss1 = 1.2;       % Power gain of first component
gGauss2 = 0.25;      % Power gain of second component
ttlSymbols = 10e4; % total number of symbols to be transmitted at this time.


for iter=1:ITER
    data = randi([0 M-1], ttlSymbols, nTx); % generated n-dimension random data.
    
for it = 1:length(snr_range)    
    %% Modulate data
    tx = pskmod(data(:), M, pi/M); % Input Modulation.
    tx = reshape(tx, ttlSymbols, nTx); % Reshape to pass the signal into wattersonMIMO
    
   
    
    [y1, g1] = chanComp1(tx);
    [y2, g2] = chanComp2(tx);
    rx = sqrt(gGauss1) * y1 ...
                                    + sqrt(gGauss2) * y2;
    
    
    rx = awgn(tx,snr_range(it));
    
    %% equalize signal without cognitive engine and get the error rate
    % LS-ZF
    y = zeros(ttlSymbols, nTx); 
    
    H_est= zeros(ttlSymbols, nTx,nRx); 
    
    for i=1:ttlSymbols
        if(mod(i-1,2)==0)
            H_est(i,:,:)=pinv(tx(i,:))*rx(i,:);
        end
            
    end
    
    for i=2:window_length:ttlSymbols
        
        H_est_temp=squeeze(mean(H_est(i-1:2:(i-1)+window_length-1,:,:),1));
    for j=i:2:i+window_length
        H_est(j,:,:)=H_est_temp;
    end
    end
    
    for i=1:ttlSymbols
            y(i,:) = rx(i,:)*pinv(squeeze(H_est(i,:,:)));

    end
    
    [~,d(it)]= biterr(pskdemod(y(:),M,pi/M),data(:));
    
    %[d_dfe_lms(it),x1] = my_dfe_lms(10,5,0.1,sum(y(:,:),2),tx(:,1),data(:,1),M);
    %[~,x2] = my_dfe_lms(10,5,0.1,sum(y(:,:),2),tx(:,2),data(:,2),M);
    tx = pskmod(data(:,1), M, pi/M); % Input Modulation.

    
    tx = reshape(tx, ttlSymbols, 1); % Reshape to pass the signal into wattersonMIMO
    
     for i=1:ttlSymbols
        if(rand<0.5)
            tx(i)=0;
        else
            tx(i)=1;
        end
    end
    rx = awgn(tx,snr_range(it));

    [est_c_dfe,est_b_dfe] = dfe_train_siso_bpsk(rx(2:2:ttlSymbols,:),tx(2:2:ttlSymbols,:),nFwdTaps,nFdbkTaps,step);

    [y_dfe] = dfe_siso_bpsk(rx(1:2:ttlSymbols,:),tx(1:2:ttlSymbols,:),nFwdTaps,nFdbkTaps,est_c_dfe,est_b_dfe);

    y_dfe=transpose(y_dfe);
    
    tx_data=tx(1:2:ttlSymbols,:);
    
    d_dfe_lms(it)=sum(y_dfe~=(tx_data(1:49991)))/49991;

    d_tot(it)=d(it)+d_tot(it);
    d_tot_dfe_lms(it)=d_dfe_lms(it)+d_tot_dfe_lms(it);
end
end
figure
d_tot=d_tot/ITER;
d_tot_dfe_lms=d_tot_dfe_lms/ITER;
plot(snr_range,d_tot)
hold on
plot(snr_range,d_tot_dfe_lms,'r')


end