function MIMO_OFDM_Watterson_baseline_v1
M = 2;
nTx = 4;
nRx = 2;
%% Initialize initial data for plots
snr_range=[0:5:30];
d_tot=zeros(1,length(snr_range));
d_tot2=zeros(1,length(snr_range));
d_tot3=zeros(1,length(snr_range));
d=zeros(1,length(snr_range));
d2=zeros(1,length(snr_range));
d3=zeros(1,length(snr_range));
fd = 1; % Chosen maximum Doppler shift for simulation
sGauss1 = 0.2;
fGauss1 = -0.5;
Rs=9600;
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
ofdmMod = comm.OFDMModulator('FFTLength',128,'NumTransmitAntennas',nTx);
ofdmDemod = comm.OFDMDemodulator(ofdmMod);
ofdmDemod.NumReceiveAntennas = nTx;
ofdmModDim = info(ofdmMod);
numData = ofdmModDim.DataInputSize(1);   % Number of data subcarriers
numSym = ofdmModDim.DataInputSize(2);    % Number of OFDM symbols
numTxAnt = ofdmModDim.DataInputSize(3);  % Number of transmit antennas
f = waitbar(0, 'Calc Started......');
ITER=100;
nframes=100;
for iter=1:ITER
    data = randi([0 M-1],nframes*numData,numSym,numTxAnt);
    tx = pskmod(data(:), M, pi/M); % Input Modulation.
    tx = reshape(tx,nframes*numData,numSym,numTxAnt); 
    for it = 1:length(snr_range)
        errorRate = comm.ErrorRate;
        errorRate2 = comm.ErrorRate;
        errorRate3 = comm.ErrorRate;
        for k = 1:nframes
            waitbar(iter/ITER,f,sprintf('Current ITER: %d, snr: %d, nframes: %d', iter, it, k));
            indData = (k-1)*ofdmModDim.DataInputSize(1)+1:k*numData;
            tx_temp = ofdmMod(tx(indData,:,:));
            [y1, ~] = chanComp1(tx_temp); % Watterson Comp1
            [y2, ~] = chanComp2(tx_temp); % Watterson Comp2
            rx = sqrt(gGauss1) * y1 + sqrt(gGauss2) * y2; % Watterson Signal
            rx = awgn(rx,snr_range(it)); % Additive White Gaussian Noise
            %H_perfect = sqrt(gGauss1) * g1 + sqrt(gGauss2) * g2; % Perfect Channel Estimation
            
            H_est=zeros(length(tx_temp),nTx,nRx);
            zf_detected=zeros(length(tx_temp),nTx);
            
            H_est_temp=pinv(tx_temp)*rx;
            for i=1:length(tx_temp)
                if(mod(i-1,7)==0)
                    H_est(i,:,:)=H_est_temp;
                else
                    H_est(i,:,:)=pinv(tx_temp(i,:))*rx(i,:);
                end
            end
            
            
            for i=1:length(tx_temp)
                zf_detected(i,:) = rx(i,:)*pinv(squeeze(H_est(i,:,:)));
            end
            
            zf_detected = ofdmDemod(zf_detected);
            zf_detected = pskdemod(zf_detected(:),M,pi/M);
            data_temp = data(indData,:,:);
            err = errorRate(data_temp(:),zf_detected);
            
            %% MMSE DETECTOR
            No = 0.1;
            mmse_detected = zeros(length(tx_temp), nTx);
            for i = 1 : length(tx_temp)
                H_temp = squeeze(H_est(i,:,:));
                W = [];
                for nr = 1 : nRx
                    w = (H_temp*H_temp' + No*eye(nTx))^(-1)*H_temp(:,nr);
                    W = [W w];
                end
                s_h = rx(i,:)*pinv(W);
                mmse_detected(i,:) = s_h;
            end
            mmse_detected = ofdmDemod(mmse_detected);
            mmse_detected = pskdemod(mmse_detected(:),M,pi/M);
            err2 = errorRate2(data_temp(:),mmse_detected(:));
            
            %% MLD DETECTOR
            mld_detected = zeros(length(tx_temp), nTx);
            for j = 1:length(rx)
                mu = zeros(1, length(tx_temp));
                for i = 1:length(tx_temp)
                    dist = sum(abs(rx(j,:) - tx_temp(i,:)*squeeze(H_est(i,:,:))).^2);
                    mu(i) = dist;
                end
                [~, idx] = min(mu);
                mld_detected(j,:,:) = tx_temp(idx,:,:);
            end
            
            mld_detected = ofdmDemod(mld_detected);
            mld_detected = pskdemod(mld_detected(:),M,pi/M);
            err3 = errorRate3(data_temp(:),mld_detected(:));
            
        end
        d(it) = err(1);
        d2(it) = err2(1);
        d3(it) = err3(1);
        d_tot(it)=d_tot(it)+d(it);
        d_tot2(it)=d_tot2(it)+d2(it);
        d_tot3(it)=d_tot3(it)+d3(it);
    end
end
close(f)
figure
d_tot=d_tot/ITER;
d_tot2=d_tot2/ITER;
d_tot3=d_tot3/ITER;
hold on;
plot(snr_range,d_tot)
plot(snr_range,d_tot2)
plot(snr_range,d_tot3)
legend('zf','mmse','mld');
hold off;
end