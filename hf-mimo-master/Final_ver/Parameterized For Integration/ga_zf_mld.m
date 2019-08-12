% I have used matlab-provided Genetic Algorithm Module.
% reference provided by, https://www.mathworks.com/help/gads/
% Genetic Algorithm for ls-zf and ls-mld.
% Optimizing Params:
%   - window_length for LS
function fval = ga_zf_mld(tx, rx, M, pilot_freq, alg)
[ttlSymbols, nTx] = size(tx);% getter transmission size variables
if alg == 1 % Zero Forcing case
    f = @(param)zf_fun(tx, rx, M, pilot_freq, param(1));
elseif alg == 2 % mld case
    f = @(param)mld_fun(tx, rx, M, pilot_freq, param(1));
end
n = 1; % number of training param
lb = [10]; % lower bounds for param
ub = [ttlSymbols]; % upper bounds for param
intvars = [1]; % params that only accept integer values.
opts = optimoptions(...
    @ga,...
    'PopInitRange',[lb;ub],'Generations',10,...
    'PopulationSize',20,'CreationFcn','gacreationuniform',...
    'CrossoverFcn', 'crossoverscattered');
[~, fval] = ga(f,n,[],[],[],[],lb,ub, [], intvars, opts);
end