function MIMO_Watterson_baseline_edit()
%% Initialize initial data for plots

    M=4;
    nTx=2; 
    nRx=2;
    snr_range=[-20:5:50];
    d=zeros(1,length(snr_range));
    for it=1:length(snr_range)
    %% Initialize Data and channels.
    fprintf('Initializing data and channel.........\n')
    ttlSymbols = 2e3; % total number of symbols to be transmitted at this time.
    data = randi([0 M-1], ttlSymbols, nTx); % generated n-dimension random data.
    sr = 12e3; % Sampling Rate. 2000/4000/6000/8000/12000
    chanModel = stdchan('iturHFMQ',sr,1);
wattersonMIMO = comm.MIMOChannel(...
    'SampleRate',sr,...
    'AveragePathGains',chanModel.AveragePathGains,...
    'PathDelays',chanModel.PathDelays,...
    'NormalizePathGains',chanModel.NormalizePathGains,...
    'MaximumDopplerShift',chanModel.MaximumDopplerShift,...
    'DopplerSpectrum',chanModel.DopplerSpectrum,...
    'SpatialCorrelationSpecification','None', ...
    'NumTransmitAntennas',nTx, ...
    'NumReceiveAntennas',nRx,...
    'PathGainsOutputPort', true);
   
    %% Modulate data
    fprintf('modulating and fading data.........\n')
    tx = pskmod(data(:), M, pi/M); % Input Modulation.
    tx = reshape(tx, ttlSymbols, nTx); % Reshape to pass the signal into wattersonMIMO
   
    %% fading modulated data
    rx = wattersonMIMO(tx); % mimo watterson channel fading
    %rx = awgn(tx, snr_range(it)); % awgn channel fading
    
    %% equalize signal without cognitive engine and get the error rate
    % LS-ZF
    y = zeros(2000, nTx); 
    
    rx_temp1(:,1)=rx(:,1);
    tx_temp1(:,1)=tx(:,1);
    rx_temp1(:,2)=rx(:,2);
    tx_temp1(:,2)=tx(:,2);
    for i=1:2000
        rx_temp2=rx_temp1(i,:);
        tx_temp2=tx_temp1(i,:);
        if(mod(i-1,2)==0)
            H_est=pinv(tx_temp2)*rx_temp2;
        end
            
        y(i,:) = rx_temp2*pinv(H_est);
    end
    y(:,1)=(y(:,1));
    y(:,2)=(y(:,2));
    [~, d(it)]=biterr(pskdemod(y(:,1),M,pi/M),data(:,1));
    end
    figure
    d
    plot(d)
end