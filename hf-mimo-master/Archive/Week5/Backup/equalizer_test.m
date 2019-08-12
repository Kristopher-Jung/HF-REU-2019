clc;
clear;
PSK_order_power = 2;
FFT_len_power = 6;
nframes = 30;
numData = (2^FFT_len_power-16)+1; % 16 = Cyclic prefix length, Number of data subcarriers
nTransmit = 2;
nReceive = 2;
sample_rate = 20e6;
signal_power = 1;
num_taps = 8;
step_size = 0.01;
RT = 1;
FF = 0.03;
numSym = 1000;
num_fts = 10;
num_fbts = 8;
Algorithm = 'LMS';
snr = 15;
PSK_order = 4;
data = rand_data_gen(PSK_order_power,nframes,numData,numSym,nTransmit);
% Initialize Watterson MIMO Channel.
chan = comm.MIMOChannel(...
    'SampleRate',sample_rate,...
    'FadingDistribution','Rayleigh',...
    'AveragePathGains',[0 0],...
    'PathDelays',[0 0.5] * 1e-3,...
    'DopplerSpectrum',doppler('Gaussian', 0.1/2),...
    'TransmitCorrelationMatrix', eye(nTransmit), ...
    'ReceiveCorrelationMatrix', eye(nReceive));

switch Algorithm
    case 'LMS'
        eq = comm.DecisionFeedbackEqualizer('Algorithm','LMS', ...
            'NumForwardTaps',num_fts,'NumFeedbackTaps',num_fbts,'StepSize',step_size, 'ReferenceTap', RT);
    case 'RLS'
        eq = comm.DecisionFeedbackEqualizer('Algorithm','RLS', ...
            'NumForwardTaps',num_fts,'NumFeedbackTaps',num_fbts,...
            'ReferenceTap', RT, 'ForgettingFactor', FF);
    case 'CMA'
        eq = comm.DecisionFeedbackEqualizer('Algorithm','CMA', ...
            'NumForwardTaps',num_fts,'NumFeedbackTaps',num_fbts,'StepSize',step_size, 'ReferenceTap', RT);
    case 'LS_ZF'
        eq = 'dummy';
end

for i=1:1000
% Initialize AWGN Channel.
awgn = comm.AWGNChannel(...
    'EbNo',snr,...
    'BitsPerSymbol',log2(PSK_order),...
    'SignalPower', signal_power);


% Modulate Data
modData = pskmod(data(:), PSK_order);
modData = reshape(modData,nframes*numData,numSym,nTransmit);

Tx = squeeze(modData);
Rx = chan(Tx);
Rx = awgn(Rx);
% Picking right Algorithm for equalization
switch Algorithm
    case 'LS_ZF'
        H_est=pinv(Tx)*Rx;
        tx_est=Rx/H_est;
    otherwise
        tx_est = eq(Tx(:), Rx(:));
end
% Demodulate PSK data
receivedData = pskdemod(tx_est(:), PSK_order);

% Compute error statistics
errorRate = comm.ErrorRate;
errors = errorRate(data(:), receivedData);
e(i) = errors(1);
end
display(mean(e))



