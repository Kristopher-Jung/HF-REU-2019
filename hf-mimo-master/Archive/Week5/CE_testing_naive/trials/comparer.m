function [e1,e2,e3,e4] = comparer(M, SNR)
numSymbols = 1.5e3;
data = randi([0 M-1], numSymbols, 2);
sr = 12000; %2000/4000/6000/8000
chan = stdchan('iturHFMQ',sr,1);
%chan = comm.RayleighChannel('SampleRate',sr,'PathDelays',[0 0.5] * 1e-3,'AveragePathGains',[0 0]);
chan.RandomStream = 'mt19937ar with seed';
chan.Visualization = 'Frequency Response';
chan.Seed = 9999;

% Input Modulation.
tx = pskmod(data(:), M, pi/M);

% Fading through Watterson Channel and AWGN Channel.
rx = chan(tx);
rx = awgn(rx, SNR);

% LS-ZF
H_est=pinv(tx)*rx;
y=rx/H_est;
d = pskdemod(y, M, pi/M);
[~,e1] = biterr(d, data(:));

% LS-MLSE
H_est=pinv(tx)*rx;
const = pskmod([0 M-1],M,pi/M);
e2 = mlse_cognitive_engine(H_est,const,M,rx,data);

% DFE-LMS
e3 = dfe_lms_cognitive_engine(rx,tx,data,M);

% DFE-RLS
e4 = dfe_rls_cognitive_engine(rx,tx,data,M);
end