% Genetic Algorithm cognitive engine specifically for dfe_lms equalizer.
function [params, e] = dfe_lms_cognitive_engine(rx,tx,data,M)
% Initialize objective Function.
f = @(param)my_dfe_lms(param(1),param(2),param(3),rx,tx,data,M);
% Options for GA CE.
n = 3; % number of training params
lb = [1 1 0.0001]; % lower bounds for params
ub = [15 15 0.01]; % upper bounds for params
intvars = [1 2]; % params that only accept integer values.
opts = optimoptions(...
    @ga,...
    'PopInitRange',[lb;ub],'Generations',100,'StallGenLimit',20,...
    'PopulationSize',50,'CreationFcn','gacreationuniform',...
    'CrossoverFcn', 'crossoverscattered');
[params,e,~,~,~] = ga(f,n,[],[],[],[],lb,ub, [], intvars, opts);
end