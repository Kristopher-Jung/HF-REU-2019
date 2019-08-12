clc;
clear;
PSK_order_power = 2;
FFT_len_power = 6;
nframes = 30;
numData = (2^FFT_len_power-16)+1; % 16 = Cyclic prefix length, Number of data subcarriers
nTransmit = 4;
nReceive = 4;
sample_rate = 20e6;
signal_power = 1;
num_taps = 8;
step_size = 0.01;
RT = 1;
FF = 0.03;
numSym = 1;
num_fts = 10;
num_fbts = 8;
Algorithm = 'LMS';
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

for snr = 1:20
    [E,P,C,EVM] = MIMO_PARAMATIZED_FUNC(...
        data, chan, snr, ...
        nTransmit, nReceive, ...
        signal_power, PSK_order_power, nframes, FFT_len_power, ...
        Algorithm, num_fts, num_fbts, step_size, RT, FF);
    e(snr) = E(1);
    p(snr) = P;
    c(snr) = C;
    evm(snr) = EVM;
end
x = 1:20;
figure
subplot(4,1,1);
plot(x, e, '-', 'LineWidth' , 1.5);
xlabel('SNR');
ylabel('BER');
subplot(4,1,2);
plot(x, p, '-');
xlabel('SNR');
ylabel('Avg power gain');
subplot(4,1,3);
plot(x, c, '-', 'LineWidth', 1.5);
xlabel('SNR');
ylabel('Capacity');
subplot(4,1,4);
plot(x, evm, '-', 'LineWidth', 1.5);
xlabel('SNR');
ylabel('EVM');
