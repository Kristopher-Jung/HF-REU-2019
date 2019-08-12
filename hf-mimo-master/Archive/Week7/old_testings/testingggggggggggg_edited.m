function testingggggggggggg_edited(M, nTx, nRx)
%% perform a simulation for each SNR
snr=15;
%% Initialize Data and channels.
fprintf('Initializing data and channel.........\n')
ttlSymbols = 2e3; % total number of symbols to be transmitted at this time.
data = randi([0 M-1], ttlSymbols, nTx); % generated n-dimension random data.
pilot_indexes=[1:2:ttlSymbols];
indexes=zeros(1,ttlSymbols);
j=1;
for i=1:ttlSymbols
    if(pilot_indexes(j)~=i)
        indexes(i)=1;
    else
        j=j+1;
        if(j>1000)
            indexes(i+1:end)=1;
            break;
        end
    end
end

[~,data_indexes]=find(indexes>0);

snr_range=[-20:5:20];
d=zeros(1,length(snr_range));
    for it=1:length(snr_range)
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
fprintf('modulating and fading data.........\n')
tx = pskmod(data(:), M, pi/M); % Input Modulation.
tx = reshape(tx, ttlSymbols, nTx); % Reshape to pass the signal into wattersonMIMO
%% fading modulated data
rx = wattersonMIMO(tx); % mimo watterson channel fading
rx = awgn(tx, snr_range(it), 'measured'); % awgn channel fading
%% equalize signal without cognitive engine and get the error rate
% LS-ZF
y = zeros(2000, nTx);
rx_temp1(:,1)=rx(:,1);
tx_temp1(:,1)=tx(:,1);
rx_temp1(:,2)=rx(:,2);
tx_temp1(:,2)=tx(:,2);
H_est_arr=zeros(size(indexes,2),nTx,nRx);
for i=pilot_indexes
    rx_temp2=rx_temp1(i,:);
    tx_temp2=tx_temp1(i,:);
    H_est_arr(i,:,:)=pinv(tx_temp2)*rx_temp2;
end

for j=1:nTx
    for k=1:nRx
        H_est_arr(data_indexes,j,k) = spline(pilot_indexes,H_est_arr(pilot_indexes,j,k),data_indexes);
    end
end



for i=1:ttlSymbols-4
    y(i,:) = rx_temp2*pinv((squeeze(H_est_arr(i,:,:))));
end



[~, d(it)]=biterr(pskdemod(y(:,1),M,pi/M),data(:,1));
    end
    figure
    d
    plot(d)
end