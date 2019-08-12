% Training Module that handles Genetic Algorithm.
% M is the modulation scheme. (2, 4, 8.....)
% Returning best set of params, error, population, and scores.
function [x,fval,population,scores] = cognitive_engine(M, SNR)
numSymbols = 1e3; % number of symbols transmitted in total.
data = randi([0 M-1],numSymbols,2); % Initialize random for training.
sr = 20e6;
chan = stdchan('iturHFMQ',sr,1);
% Initialize objective Function.
f = @(param)objectiveFunction(...
    data, chan, M, SNR, [param(1) param(2) param(3) param(4) param(5) param(6)]);
% Initialize Plotting
plots = {@gaplotbestf, @gaplotbestindiv};
% Options for GA CE.
opts = optimoptions(...
    @ga,'FunctionTolerance',0.001,'FitnessLimit', 0.04);
%'PlotFcn',plots, ...'Display', 'iter',
n = 6; % number of training params
lb = [1 4 4 0.00001 0.1 1]; % lower bounds for params
ub = [4 15 15 0.001 0.99 3]; % upper bounds for params
intvars = [1 2 3 6]; % params that only accept integer values.
[x,fval,~,population,scores] = ga(f,n,[],[],[],[],lb,ub, [], intvars, opts); % running GA CE
end