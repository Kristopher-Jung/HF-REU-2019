function testing
clc;
clear;
%% Testing vars
nTx=2;
nRx=2;
M=4;
ttlSymbols = 10e6;
data = randi([0 M-1], ttlSymbols, nTx);
sr = 9.6e3;
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
for snr = 1:15
    for i = 1 : 100
        %% Trying 3 (Only thing that close to work now)
        tx = pskmod(data(:), M,pi/M);
        tx = reshape(tx, ttlSymbols, nTx);
        [rx, ~] = wattersonMIMO(tx);
        rx = awgn(rx, snr, 'measured');
        H_est = pinv(tx)*rx;
        y = rx*pinv(H_est);
        [~,e(i)] = biterr(pskdemod(y(:), M, pi/M), data(:));
    end
    fprintf('%d\n',100*snr/1500);
    ber(snr) = mean(e);
end
figure;
hold on;
plot(ber);
grid on;
xlabel('SNR');
ylabel('BER');
hold off;

%% Trying 2 (works but not realistic at all)
% for nt = 1 : nTx
%     t_select = zeros(1,nTx);
%     t_select(nt) = 1;
%     for nr = 1 : nRx
%         r_select = zeros(1,nRx);
%         r_select(nr) = 1;
%         [rx, ~] = wattersonMIMO(tx(:,nt), t_select, r_select);
%         rx = awgn(rx, snr, 'measured');
%         eq = comm.DecisionFeedbackEqualizer('Algorithm','LMS', ...
%             'NumForwardTaps',15,'NumFeedbackTaps',6,'ReferenceTap',1, ...
%             'StepSize',0.01);
%         x_hat = eq(rx, tx(:,nt));
%         [~, r]=biterr(pskdemod(x_hat,M,pi/M),data(:,nt));
%         fprintf('bit error rate: %d.\n',r);
%         reset(wattersonMIMO);
%         reset(eq);
%     end
% end
%scatterplot(x_hat(:));
end