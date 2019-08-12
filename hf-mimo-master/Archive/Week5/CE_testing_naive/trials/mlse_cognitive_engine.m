function e = mlse_cognitive_engine(Channel,Constellation,M,rx,data)
% Initialize objective Function.
f = @(param)my_mlse(Channel,Constellation,M,rx,data,param(1));
% Options for GA CE.
n = 1; % number of training params
lb = [1]; % lower bounds for params
ub = [10]; % upper bounds for params
intvars = [1]; % params that only accept integer values.
opts = optimoptions(...
    @ga,...
    'PopInitRange',[lb;ub],'Generations',100,'StallGenLimit',20,...
    'PopulationSize',100,'CreationFcn','gacreationuniform',...
    'CrossoverFcn', 'crossoverscattered');
[~,e,~,~,~] = ga(f,n,[],[],[],[],lb,ub, [], intvars, opts);
end