function testingggggggggggg(M, nTx, nRx)
%% perform a simulation for each SNR
snr=15;
%% Initialize Data and channels.
fprintf('Initializing data and channel.........\n')
ttlSymbols = 2e3; % total number of symbols to be transmitted at this time.
data = randi([0 M-1], ttlSymbols, nTx); % generated n-dimension random data.
pilot_indexes=[1:5:ttlSymbols];
indexes=zeros(1,ttlSymbols);
j=1;
for i=1:ttlSymbols
    if(pilot_indexes(j)~=i)
        indexes(i)=1;
    else
        j=j+1;
        if(j>400)
            indexes(i+1:end)=1;
            break;
        end
    end
end

[~,data_indexes]=find(indexes>0);


sr = 12000; % Sampling Rate. 2000/4000/6000/8000/12000
chanModel = stdchan(1/sr,1,'iturHFMQ');
% create the actual channel we will pass the signal through
wattersonMIMO = comm.MIMOChannel('SampleRate',sr,'FadingDistribution','Rayleigh',...
    'AveragePathGains',chanModel.AvgPathGaindB,...
    'PathDelays',chanModel.PathDelays,'NormalizePathGains',chanModel.NormalizePathGains,...
    'MaximumDopplerShift',chanModel.MaxDopplerShift,'DopplerSpectrum',chanModel.DopplerSpectrum,...
    'TransmitCorrelationMatrix', eye(nTx), 'ReceiveCorrelationMatrix', eye(nRx));
%% Modulate data
fprintf('modulating and fading data.........\n')
tx = pskmod(data(:), M, pi/M); % Input Modulation.
tx = reshape(tx, ttlSymbols, nTx); % Reshape to pass the signal into wattersonMIMO
%% fading modulated data
rx = wattersonMIMO(tx); % mimo watterson channel fading
rx = awgn(rx, snr, 'measured'); % awgn channel fading
%% equalize signal without cognitive engine and get the error rate
% LS-ZF
y = zeros(2000, nRx);
rx_temp1(:,1)=fftshift(fft(rx(:,1)))/sqrt(2000);
tx_temp1(:,1)=fftshift(fft(tx(:,1)))/sqrt(2000);
rx_temp1(:,2)=fftshift(fft(rx(:,2)))/sqrt(2000);
tx_temp1(:,2)=fftshift(fft(tx(:,2)))/sqrt(2000);
H_est_arr=zeros(size(indexes,2),nTx,nRx);
for i=pilot_indexes
    rx_temp2=rx_temp1(i,:);
    tx_temp2=tx_temp1(i,:);
    H_est_arr(i,:,:)=pinv(tx_temp2)*rx_temp2;
end

for j=1:nTx
    for k=1:nRx
        H_interpolated_real=interp1(pilot_indexes,real(H_est_arr(pilot_indexes,j,k)),data_indexes);
        H_interpolated_imag=interp1(pilot_indexes,imag(H_est_arr(pilot_indexes,j,k)),data_indexes);
        H_est_arr(data_indexes,j,k) = complex(H_interpolated_real,H_interpolated_imag);
    end
end

for i=1:ttlSymbols-4
    y(i,:) = rx_temp2*pinv(squeeze(H_est_arr(i,:,:)))*sqrt(2000);
end

y(:,1)=ifft(y(:,1))*sqrt(2000);
y(:,2)=ifft(y(:,2))*sqrt(2000);
[~, r]=biterr(pskdemod(y(:),M,pi/M),data(:));
display(r);
scatterplot(y(:));
end