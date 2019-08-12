<<<<<<< HEAD
function MIMO_Watterson_baseline_edited
M = 2;
nTx = 2;
nRx = 2;
%% Initialize initial data for plots
ITER=100;
snr_range=[0:5:15];
d_tot=zeros(1,length(snr_range));
d_tot2=zeros(1,length(snr_range));
d_tot3=zeros(1,length(snr_range));
d_tot4=zeros(1,length(snr_range));
d=zeros(1,length(snr_range));
d2=zeros(1,length(snr_range));
d3=zeros(1,length(snr_range));
d4=zeros(1,length(snr_range));
fd = 1; % Chosen maximum Doppler shift for simulation
window_length=10;
ttlSymbols = 50; % total number of symbols to be transmitted at this time.
sGauss1 = 0.2;
fGauss1 = -0.5;
Rs=9600;
=======
function d_tot = MIMO_Watterson_baseline_edited(M, snr_range, nTx, nRx)
%% Initialize initial data for plots
ITER=100;
snr_range=[0:5:30];
d_tot=zeros(1,length(snr_range));
d=zeros(1,length(snr_range));
fd = 1; % Chosen maximum Doppler shift for simulation
window_length=100;
sGauss1 = 0.2;
fGauss1 = -0.5;
Rs=9600;


>>>>>>> 3c6ab908e7fef988130b2ad2031283cffa58cb49
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
<<<<<<< HEAD
    'SpatialCorrelationSpecification', 'None' );
=======
     'SpatialCorrelationSpecification', 'None' );
>>>>>>> 3c6ab908e7fef988130b2ad2031283cffa58cb49
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
<<<<<<< HEAD
for iter=1:ITER
    data = randi([0 M-1], ttlSymbols, nTx); % generated n-dimension random data.
    for it = 1:length(snr_range)
        tx = pskmod(data(:), M, pi/M); % Input Modulation.
        tx = reshape(tx, ttlSymbols, nTx); % Reshape to pass the signal into wattersonMIMO
        [y1, g1] = chanComp1(tx); % Watterson Comp1
        [y2, g2] = chanComp2(tx); % Watterson Comp2
        rx = sqrt(gGauss1) * y1 + sqrt(gGauss2) * y2; % Watterson Signal
        rx = awgn(rx,snr_range(it)); % Additive White Gaussian Noise
        H_perfect = sqrt(gGauss1) * g1 + sqrt(gGauss2) * g2; % Perfect Channel Estimation
        %% LEAST SQUARE - ZERO FORCING
        y = zeros(ttlSymbols, nTx);
        H_est= zeros(ttlSymbols, nTx,nRx); % Least Squal Channel Estimation
        for i=1:ttlSymbols % Pilots
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
        d_tot(it)=d(it)+d_tot(it);
        %% MLD DETECTOR
        detected = zeros(ttlSymbols, nTx);
        H = squeeze(H_perfect);
        for j = 1:ttlSymbols
            mu = zeros(1, ttlSymbols);
            for i = 1:ttlSymbols
                dist = sum(abs(rx(j,:) - tx(i,:)*squeeze(H_est(i,:,:))).^2);
                mu(i) = dist;
            end
            [~, idx] = min(mu);
            detected(j,:,:) = tx(idx,:,:);
        end
        
        [~,d2(it)]= biterr(pskdemod(detected(:),M,pi/M),data(:));
        d_tot2(it)=d2(it)+d_tot2(it);
        %% MMSE DETECTOR
        No = 0.1;
        detected = zeros(ttlSymbols, nTx);
        for i = 1 : ttlSymbols
            H_temp = squeeze(H_est(i,:,:));
            W = [];
            for nr = 1 : nRx
                w = (H_temp*H_temp' + No*eye(nTx))^(-1)*H_temp(:,nr);
                W = [W w];
            end
            %s_h = W'*reshape(rx(i,:), nRx, 1);
            s_h = rx(i,:)*pinv(W);
            detected(i,:) = s_h;
        end
        [~,d3(it)]= biterr(pskdemod(detected(:),M,pi/M),data(:));
        d_tot3(it)=d3(it)+d_tot3(it);
        %% DFE
        estimated_c_dfe=ones(ttlSymbols,nTx); %feed forward
        estimated_b_dfe=ones(ttlSymbols,nRx); %feed back
        a_tilda_dfe=ones(nTx,ttlSymbols-(nTx-1)); %training sequence tilda
        delta=0.01;
        for k=1:10-(nTx-1)
            y_k_dfe=rx(k:k+nTx-1,:);
            z_k_ff_dfe=estimated_c_dfe*y_k_dfe';
            if k == 1
                a_tilda_k_dfe=ones(nTx,2);
            elseif k==2
                a_tilda_k_dfe=[0 a_tilda_dfe(1);0 a_tilda_dfe(1)];
            else
                a_tilda_k_dfe=a_tilda_dfe(:,k-nRx:k-1);
            end
            z_k_fb_dfe=estimated_b_dfe*a_tilda_k_dfe';
            z_k_dfe=z_k_ff_dfe-z_k_fb_dfe;
            if z_k_dfe<0
                a_tilda_dfe(k)=0;
            end
            e_k_dfe=pskdemod(tx(k,:),M,pi/M)-z_k_dfe;
            estimated_c_dfe=estimated_c_dfe+delta*e_k_dfe*y_k_dfe;
            estimated_b_dfe=estimated_b_dfe-delta*e_k_dfe*a_tilda_k_dfe;
        end
        err_count_dfe=0;
        count_dfe=0;
        for k=1:ttlSymbols-(nTx-1)
            y_k_dfe=rx(k:k+nTx-1,:);
            z_k_ff_dfe=estimated_c_dfe*y_k_dfe';
            if k == 1
                a_tilda_k_dfe=ones(nTx,2);
            elseif k==2
                a_tilda_k_dfe=[0 a_tilda_dfe(1);0 a_tilda_dfe(1)];
            else
                a_tilda_k_dfe=a_tilda_dfe(:,k-nRx:k-1);
            end
            z_k_fb_dfe=estimated_b_dfe*a_tilda_k_dfe';
            z_k_dfe=z_k_ff_dfe-z_k_fb_dfe;
            if z_k_dfe<0
                a_tilda_dfe(k)=0;
            end
            count_dfe=count_dfe+1;
            z_k_vec_dfe(count_dfe)=a_tilda_dfe(k);
            err_count_dfe=err_count_dfe+0.5*abs(pskdemod(tx(k,:),M,pi/M)-a_tilda_dfe(k));
        end
        yz=err_count_dfe/length(z_k_vec_dfe);  
        d4(it)=mean(yz);
        
        %[~,d4(it)]= biterr(pskdemod(r(:),M,pi/M),data(:));
        d_tot4(it)=d4(it)+d_tot4(it);
    end
end
figure
d_tot=d_tot/ITER;
d_tot2=d_tot2/ITER;
d_tot3=d_tot3/ITER;
d_tot4=d_tot4/ITER;
hold on;
plot(snr_range,d_tot)
plot(snr_range,d_tot2)
plot(snr_range,d_tot3)
plot(snr_range,d_tot4)
legend('zf','MLD','MMSE', 'DFE');
hold off;
=======
ttlSymbols = 2e3; % total number of symbols to be transmitted at this time.


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
    
    
    rx = awgn(rx,snr_range(it));
    
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
        i
        H_est_temp=squeeze(mean(H_est(i-1:2:(i-1)+window_length-1,:,:),1));
    for j=i:2:i+window_length
        H_est(j,:,:)=H_est_temp;
    end
    end
    
    for i=1:ttlSymbols
            y(i,:) = rx(i,:)*pinv(squeeze(H_est(i,:,:)));

    end
    
    [~,d(it)]= biterr(pskdemod(y(:),M,pi/M),data(:));
    

    d_tot(it)=d(it)+d_tot(it);
end
end
figure
d_tot=d_tot/ITER;
plot(snr_range,d_tot)
    

>>>>>>> 3c6ab908e7fef988130b2ad2031283cffa58cb49
end