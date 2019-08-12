function MIMO_Watterson_baseline(M, snr_range, nTx, nRx)
%% Initialize initial data for plots
fprintf('Initializing Plots....\n')
raw_data_1 = nan(100,1);
raw_data_2 = nan(100,1);
ttlSymbols = 2e3;
raw_modulated = nan(ttlSymbols*nTx,1);
y = nan(ttlSymbols,1);
y_eq = nan(ttlSymbols,1);
w1 = nan(snr_range,1);
w2 = nan(snr_range,1);
w3 = nan(snr_range,1);
w4 = nan(snr_range,1);
%% initialize raw data plot
figure; % create a figure
subplot(2,2,1);
hold on;
raw_plot_1 = stairs(raw_data_1);
raw_plot_2 = stairs(raw_data_2);
legend('symbols transmitted tx1','symbols transmitted tx2');
xlabel('Symbols');
ylabel('Raw Data');
title('Random Data Generated');
hold off;
%% initialize modulated signal plot
subplot(2,2,2);
hold on;
raw_modulated_plot = plot(raw_modulated,'.');
axis square;
axis([-1.2 1.2 -1.2 1.2]);
grid on;
xlabel('In-phase');
ylabel('Quadrature');
title(sprintf('Scatter Plot: raw-modulated'));
legend(sprintf('%d-PSK',M));
hold off;
%% Initialize BER plot
subplot(2,2,3);
axis([1 snr_range 0 1]);
hold on;
error_plot1 = plot(w1,'LineWidth',1);
error_plot2 = plot(w2,'LineWidth',1);
error_plot3 = plot(w3,'LineWidth',1);
error_plot4 = plot(w4,'LineWidth',1);
hold off;
grid on;
xlabel('SNR');
ylabel('Bit Error Rate');
ylim([0 1]);
title('BER plot');
legend('CE BER','LS-ZF BER','lms-NO-CE', 'rls-NO-CE');
%% initialize pre/equalized signal plot
subplot(2,2,4);
scatPlot = plot(y,'.');
hold on;
scatPlot_eq = plot(y_eq,'.');
axis square;
axis([-1.2 1.2 -1.2 1.2]);
grid on;
xlabel('In-phase');
ylabel('Quadrature');
title(sprintf('Scatter Plot'));
legend('pre-equalized','equalized');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
hold off;
fprintf('Simulation started....\n');
%% perform a simulation for each SNR
for snr = 1:snr_range
    %% Initialize Data and channels.
    fprintf('Initializing data and channel.........\n')
    ttlSymbols = 2e3; % total number of symbols to be transmitted at this time.
    data = randi([0 M-1], ttlSymbols, nTx); % generated n-dimension random data.
    sr = 12000; % Sampling Rate. 2000/4000/6000/8000/12000
    chanModel = stdchan('iturHFMQ',sr,1);
    % create the actual channel we will pass the signal through
    wattersonMIMO = comm.MIMOChannel('SampleRate',sr,"FadingDistribution",'Rayleigh',...
        "AveragePathGains",chanModel.AveragePathGains,...
        "PathDelays",chanModel.PathDelays,"NormalizePathGains",chanModel.NormalizePathGains,...
        "MaximumDopplerShift",chanModel.MaximumDopplerShift,"DopplerSpectrum",chanModel.DopplerSpectrum,...
        "TransmitCorrelationMatrix", eye(nTx), "ReceiveCorrelationMatrix", eye(nRx));
    %% plot 100 sample raw data transmitted
    raw_plot_1.YData = data(1:100,1);
    raw_plot_2.YData = data(1:100,2);
    %% Modulate data
    fprintf('modulating and fading data.........\n')
    tx = pskmod(data(:), M, pi/M); % Input Modulation.
    tx = reshape(tx, ttlSymbols, nTx); % Reshape to pass the signal into wattersonMIMO
    %% update modulated data plot.
    raw_modulated_plot.XData = real(tx(:));
    raw_modulated_plot.YData = imag(tx(:));
    %% fading modulated data
    rx = wattersonMIMO(tx); % mimo watterson channel fading
    rx = awgn(rx, snr, 'measured'); % awgn channel fading
    %% PERFORM EQUALIZATION AND CHANNEL ESTIMATION USING CE
    fprintf('PERFORM EQUALIZATION AND CHANNEL ESTIMATION USING CE...\n');
    [w1(snr), ~] = equalizer_picker(rx, tx, M, data);
    %% update equalized constellation with GA constellation.
    %scatPlot_eq.XData = real(yy);
    %scatPlot_eq.YData = imag(yy);
    %% equalize signal without cognitive engine and get the error rate
    % LS-ZF
    H_est=pinv(tx)*rx; % Lease Square
    y=rx/H_est; % Zero Forcing Equalizer
    d = pskdemod(y, M, pi/M); % Demodulation
    [~,w2(snr)] = biterr(d(:), data(:));
    % LS-ZF-DFE-LMS
    H_est=pinv(tx)*rx; % Lease Square
    y=rx/H_est; % Zero Forcing Equalizer
    [w3(snr),~] = my_dfe_lms(1,1,0.1,tx,y,data,M); % DFE-LMS
    % LS-ZF-DFE-RLS
    H_est=pinv(tx)*rx; % Lease Square
    y=rx/H_est; % Zero Forcing Equalizer
    [w4(snr),~] = my_dfe_rls(10,10,tx,y,data,M); % DFE-RLS
    %% update bers
    error_plot1.YData = w1;
    error_plot2.YData = w2;
    error_plot3.YData = w3;
    error_plot4.YData = w4;
    drawnow limitrate
end
end