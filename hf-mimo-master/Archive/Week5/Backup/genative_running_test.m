clc;
clear;
rng default;
% Initialize random data.
FFT_len_power = 6;
nframes = 30;
numData = (2^FFT_len_power-16)+1; % 16 = Cyclic prefix length, Number of data subcarriers
nTransmit = 2;
nReceive = 2;
signal_power = 1;
RT = 1;
numSym = 100;
PSK_order_power = 2; % QPSK
data = rand_data_gen(PSK_order_power,nframes,numData,numSym,nTransmit);

% Initialize Watterson MIMO Channel.
chan = comm.MIMOChannel(...
    'SampleRate',9.6e3,...
    'FadingDistribution','Rayleigh',...
    'AveragePathGains',[0 0],...
    'PathDelays',[0 0.5] * 1e-3,...
    'DopplerSpectrum',doppler('Gaussian', 0.1/2),...
    'TransmitCorrelationMatrix', eye(nTransmit), ...
    'ReceiveCorrelationMatrix', eye(nReceive));

f = @(params) generative_testing(...
    {params(1),params(2),params(3),params(4),params(5),params(6),data,chan},...
    PSK_order_power, FFT_len_power,...
    nframes, nTransmit, nReceive,...
    signal_power,RT); % Objective Function

maxGens = 10; % max number of generations to run
plots = {@gaplotbestf, @gaplotbestindiv, @gaplotgenealogy}; % set of plots to generate
opts = optimoptions(@ga,'MaxGeneration',maxGens,'PlotFcn',plots, 'Display', 'iter');
n = 6;
lb = [1 1 0.0001 5 5 1];
ub = [15 4 0.001 15 15 5];
intvars = [1 2 4 5 6];
[x,fval,~,population,scores] = ga(f,n,[],[],[],[],lb,ub, [], intvars, opts);
