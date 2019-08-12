% Training Module that handles Genetic Algorithm.
% M is the modulation scheme. (2, 4, 8.....)
% Returning best set of params, error, population, and scores.
function [x,fval,population,scores] = cognitive_engine_bound(M, SNR, lb, ub, intvars)
numSymbols = 1e3; % number of symbols transmitted in total.
data = randi([0 M-1],numSymbols,2); % Initialize random for training.
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
% Initialize Watterson MIMO Channel assuming 2x2 MIMO
chan = comm.MIMOChannel(...
    'SampleRate',sr,...
    'FadingDistribution','Rayleigh',...
    'AveragePathGains',[0 0],...
    'PathDelays',[0 0.5] * 1e-3,...
    'DopplerSpectrum',doppler('Gaussian', 0.1/2),...
    'TransmitCorrelationMatrix', eye(2), ...
    'ReceiveCorrelationMatrix', eye(2));
% Initialize objective Function.
f = @(param)objectiveFunction(...
    data, chan, M, SNR, [param(1) param(2) param(3) param(4) param(5) param(6)]);
% Initialize Plotting
plots = {@gaplotbestf, @gaplotbestindiv};
% Options for GA CE.
opts = optimoptions(...
    @ga,'FunctionTolerance',0.001,'FitnessLimit', 0.04);
n = 6; % number of training params
[x,fval,~,population,scores] = ga(f,n,[],[],[],[],lb,ub, [], intvars, opts); % running GA CE
end