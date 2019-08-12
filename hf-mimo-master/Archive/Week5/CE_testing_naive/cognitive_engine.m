function [x,fval,population,scores] = cognitive_engine(M, SNR)
numSymbols = 10000;
data = randi([0 M-1], numSymbols, 2);
sr = 20e6;
chan = stdchan('iturHFMQ',sr,1);
% Initialize objective Function.
f = @(param)objectiveFunction(...
    data, chan, M, SNR, [param(1) param(2) param(3) param(4)]);
% Initialize Plotting
plots = {@gaplotbestf, @gaplotbestindiv};
% Options for GA CE.
opts = optimoptions(...
    @ga,...
    'FunctionTolerance',0.001,'FitnessLimit', 0.001,...
    'MaxStallGenerations', 3,...
    'Display', 'iter', 'PlotFcn', plots);
n = 4; % number of training params
lb = [1 1 0.0001 2]; % lower bounds for params
ub = [15 15 0.001 3]; % upper bounds for params
intvars = [1 2 4]; % params that only accept integer values.
[x,fval,~,population,scores] = ga(f,n,[],[],[],[],lb,ub, [], intvars, opts); % running GA CE
end