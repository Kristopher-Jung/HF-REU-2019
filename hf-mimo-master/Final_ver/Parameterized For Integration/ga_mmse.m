% I have used matlab-provided Genetic Algorithm Module.
% reference provided by, https://www.mathworks.com/help/gads/
% Genetic Algorithm for mmse. Optimizing ls-mmse equalizer
% Optimizing Params:
%   - window_length for LS
%   - variance for mmse.
function fval = ga_mmse(tx, rx, M, pilot_freq, snr_range)
[ttlSymbols, nTx] = size(tx);% getter transmission size variables
f = @(param)mmse_fun(tx, rx, M, pilot_freq, param(1), param(2));
n = 2; % number of training param
var_lb = 10^(-max(snr_range));
var_ub = 10^(min(snr_range));
lb = [10 var_lb]; % lower bounds for param
ub = [ttlSymbols var_ub]; % upper bounds for param
intvars = [1]; % params that only accept integer values.
opts = optimoptions(...
    @ga,...
    'PopInitRange',[lb;ub],'Generations',30,...
    'PopulationSize',20,'CreationFcn','gacreationuniform',...
    'CrossoverFcn', 'crossoverscattered');
[~, fval] = ga(f,n,[],[],[],[],lb,ub, [], intvars, opts);
end