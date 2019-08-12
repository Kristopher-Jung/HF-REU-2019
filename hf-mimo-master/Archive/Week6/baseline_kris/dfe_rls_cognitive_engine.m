% cognitive engine for dfe_rls
function [params, e] = dfe_rls_cognitive_engine(rx,tx,data,M)
% Initialize objective Function.
f = @(param)my_dfe_rls(param(1),param(2),rx,tx,data,M);
% Options for GA CE.
n = 2; % number of training params
lb = [1 1]; % lower bounds for params
ub = [15 15]; % upper bounds for params
intvars = [1 2]; % params that only accept integer values.
opts = optimoptions(...
    @ga,...
    'PopInitRange',[lb;ub],'Generations',100,'StallGenLimit',20,...
    'PopulationSize',50,'CreationFcn','gacreationuniform',...
    'CrossoverFcn', 'crossoverscattered');
[params,e,~,~,~] = ga(f,n,[],[],[],[],lb,ub, [], intvars, opts); % running GA CE
end