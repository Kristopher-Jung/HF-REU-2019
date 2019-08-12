function MIMO_Watterson_baseline
clc;
clear;
%% Testing vars
nTx=3;
nRx=4;
snr=15;
M=4;
%% Initialize Data and channels.
ttlSymbols = 2e3;
data = randi([0 M-1], ttlSymbols, nTx);
pilot_indexes=1:5:ttlSymbols;
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
        
sr = 9.6e3;
chanModel = stdchan('iturHFMQ',sr,1);
wattersonMIMO = comm.MIMOChannel('SampleRate',sr,...
    "AveragePathGains",chanModel.AveragePathGains,...
    "PathDelays",chanModel.PathDelays,"NormalizePathGains",chanModel.NormalizePathGains,...
    "MaximumDopplerShift",chanModel.MaximumDopplerShift,"DopplerSpectrum",chanModel.DopplerSpectrum,...
    "TransmitCorrelationMatrix", eye(nTx), "ReceiveCorrelationMatrix", eye(nRx));
%% Modulate data
tx = pskmod(data(:), M,pi/M);
tx = reshape(tx, ttlSymbols, nTx);
%% fading modulated data
rx = wattersonMIMO(tx);
rx = awgn(rx, snr, 'measured');
%% testing equalizer.
x_hat = nan(ttlSymbols, nTx);
j=1;
H_est_arr=zeros(size(indexes,2),nTx,nRx);
for i=pilot_indexes
    H_est_arr(i,:,:) = pinv(tx(i,:))*rx(i,:);
end

   
for j=1:nTx
    for k=1:nRx
            H_interpolated_real=interp1(pilot_indexes,real(H_est_arr(pilot_indexes,j,k)),data_indexes);
            H_interpolated_imag=interp1(pilot_indexes,imag(H_est_arr(pilot_indexes,j,k)),data_indexes);
            H_est_arr(data_indexes,j,k) = complex(H_interpolated_real,H_interpolated_imag);
    end
end


for i = 1:ttlSymbols-4
    x_hat(i,:) = rx(i,:)*pinv(squeeze(H_est_arr(i,:,:)));
end

%[~, r]=biterr(pskdemod(x_hat(:),M,pi/M),data(:));
%fprintf('bit error rate: %d.\n',r);
scatterplot(x_hat(:));
end