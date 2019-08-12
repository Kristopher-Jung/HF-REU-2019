function [d_tot1,d_tot2]=MIMO_Watterson_baseline_new
%% Environment Specific Params
M=2;
nTx=2;
nRx=2;
pilot_interval=2;
window_length=100;
ITER=1;
%% Model and Simulation Specific Params
snr_range=1:2:15;
d_tot1=zeros(1,length(snr_range));
d_tot2=zeros(1,length(snr_range));
d1=zeros(1,length(snr_range));
d2=zeros(1,length(snr_range));
fd = 1; % Chosen maximum Doppler shift for simulation
sGauss1 = 0.2;
fGauss1 = -0.5;
sGauss2 = 0.1;
fGauss2 = 0.4;
gGauss1 = 1.2;       % Power gain of first component
gGauss2 = 0.25;      % Power gain of second component
ttlSymbols = 2e3; % total number of symbols to be transmitted at this time.
Rs=9.6e3;
dopplerComp1 = doppler('BiGaussian', ...
    'NormalizedStandardDeviations', [sGauss1/fd 1/sqrt(2)], ...
    'NormalizedCenterFrequencies',  [fGauss1/fd 0], ...
    'PowerGains',                   [0.5        0]);
chanComp1 = comm.MIMOChannel( ...
    'SampleRate',          Rs, ...
    'MaximumDopplerShift', fd, ...
    'DopplerSpectrum',     dopplerComp1, ...
    'PathGainsOutputPort', true,...
    'NumTransmitAntennas', nTx,...
    'NumReceiveAntennas', nRx,...
    'SpatialCorrelationSpecification', 'None' );
dopplerComp2 = doppler('BiGaussian', ...
    'NormalizedStandardDeviations', [sGauss2/fd 1/sqrt(2)], ...
    'NormalizedCenterFrequencies',  [fGauss2/fd 0], ...
    'PowerGains',                   [0.5        0]);
chanComp2 = comm.MIMOChannel( ...
    'SampleRate',          Rs, ...
    'MaximumDopplerShift', fd, ...
    'DopplerSpectrum',     dopplerComp2,...
    'PathGainsOutputPort', true,...
    'NumTransmitAntennas', nTx,...
    'NumReceiveAntennas', nRx,...
    'SpatialCorrelationSpecification', 'None');
%% Simulation
for iter=1:ITER
    data = randi([0 M-1], ttlSymbols, nTx); % generated n-dimension random data.
    tx = pskmod(data(:), M, pi/M); % Input Modulation.
    tx = reshape(tx, ttlSymbols, nTx); % Reshape to pass the signal into wattersonMIMO
    [y1, ~] = chanComp1(tx);
    [y2, ~] = chanComp2(tx);
    for it = 1:length(snr_range)
        rx = sqrt(gGauss1) * y1 + sqrt(gGauss2) * y2;
        rx = awgn(rx,snr_range(it),'measured');
        
        H_est= zeros(ttlSymbols, nTx,nRx);
        
        for i=1:ttlSymbols
            if(mod(i-1,pilot_interval)==0)
                H_est(i,:,:)=pinv(tx(i,:))*rx(i,:);
            end          
        end
        
        for i=2:window_length:ttlSymbols-window_length
            H_est_temp=squeeze(mean(H_est(i-1:pilot_interval:(i-1)+window_length,:,:),1));
            for j=i:pilot_interval:i+window_length
                H_est(j,:,:)=H_est_temp;
            end
        end
        
%         H_est = pinv(tx)*rx;
%         zf = rx*pinv(H_est);
        
        eq = comm.DecisionFeedbackEqualizer('Algorithm','LMS', ...
            'NumForwardTaps',4,'NumFeedbackTaps',3, 'StepSize', 0.0001,...
            'ReferenceTap',1);
        
%        dfe = eq(zf(:), tx(:));
        
        
        zf = zeros(ttlSymbols, nTx);
        
        for i=1:ttlSymbols
            zf(i,:) = rx(i,:)*pinv(squeeze(H_est(i,:,:)));
        end
        [~,d1(it)]= biterr(pskdemod(zf(:),M,pi/M),data(:));
        d_tot1(it)=d1(it)+d_tot1(it);
        
        %[~,d2(it)]= biterr(pskdemod(dfe(:),M,pi/M),data(:));
        [~, d2(it)] = dfe_lms_cognitive_engine(zf(:), tx(:), data(:), M);
        d_tot2(it)=d2(it)+d_tot2(it);
    end
end
figure
d_tot1=d_tot1/ITER;
d_tot2=d_tot2/ITER;
hold on;
plot(snr_range,d_tot1)
display(d_tot1);
plot(snr_range,d_tot2)
display(d_tot2);
legend('zf', 'zfdfe');
hold off;

end