clc;
clear;
numSymbols = 1e4; % number of symbols transmitted in total.
M=4;
data = randi([0 M-1],numSymbols,2); % Initialize random for training.
SNR=15;
switch M
    % Picking low Sampling Rates standards
    % for the current modulation scheme in 6kHz bandwidth.
    case 2
        sr = 3.2e3;
    case 4
        sr = 6.4e3;
    case 8
        sr = 9.6e3;
    case 16
        sr = 12.8e3;
    case 32
        sr = 16e3;
    case 64
        sr = 19.2e3;
end
chan = stdchan('iturHFMQ',sr,1);

nFwdTaps = 1;
nFdbkTaps = 1;
stepsz =  0.0008;
alg = 2;

input = [nFwdTaps,nFdbkTaps, stepsz, alg];
e = objectiveFunction(data, chan, M, SNR, input);










