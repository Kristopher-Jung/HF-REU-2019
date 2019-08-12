function [x,fval,population,scores] = cognitive_engine(M, SNR)
numSymbols = 1e3;
data = randi([0 M-1], numSymbols, 2);
sr = 9.6e3;
chan = stdchan('iturHFMQ',sr,1);
chan.RandomStream = 'mt19937ar with seed';
chan.Seed = 9999;
% Initialize objective Function.
f = @(param)objectiveFunction(...
    data, chan, M, SNR, [param(1) param(2) param(3) param(4)]);
% Initialize Plotting
plots = {@gaplotbestf, @gaplotbestindiv};
% Options for GA CE.
n = 4; % number of training params
lb = [1 1 0.0001 1]; % lower bounds for params
ub = [15 15 0.01 4]; % upper bounds for params
intvars = [1 2 4]; % params that only accept integer values.
opts = optimoptions(...
    @ga,...
    'PopInitRange',[lb;ub],'Generations',1000,'StallGenLimit',20,...
    'PopulationSize',50,'CreationFcn','gacreationuniform',...
    'CrossoverFcn', 'crossoverscattered',...
    'Display', 'iter', 'PlotFcn', plots);
[x,fval,~,population,scores] = ga(f,n,[],[],[],[],lb,ub, [], intvars, opts); % running GA CE
end