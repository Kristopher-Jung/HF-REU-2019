% Genetic Algorithm cognitive engine specifically for dfe_lms equalizer.
function [params, e] = dfe_rls_cognitive_engine(Xest, dPsk, d, M)
% Initialize objective Function.
f = @(param)my_dfe_rls(Xest, dPsk, d, param(1), param(2), param(3), M);
% Options for GA CE.
n = 3; % number of training params
lb = [1 1 0.1]; % lower bounds for params
ub = [15 15 0.9]; % upper bounds for params
intvars = [1 2]; % params that only accept integer values.
opts = optimoptions(...
    @ga,...
    'PopInitRange',[lb;ub],'Generations',100,'StallGenLimit',20,...
    'PopulationSize',50,'CreationFcn','gacreationuniform',...
    'CrossoverFcn', 'crossoverscattered');
[params,e,~,~,~] = ga(f,n,[],[],[],[],lb,ub, [], intvars, opts);
end

function e = my_dfe_rls(Xest, dPsk, d, fwtaps, fbtaps, ff, M)
eq = comm.DecisionFeedbackEqualizer('Algorithm','RLS', ...
    'NumForwardTaps',fwtaps,'NumFeedbackTaps',fbtaps,'ReferenceTap',1,...
    'ForgettingFactor', ff,...
    'Constellation',pskmod([0 M-1],M,pi/M));
Xeqd = eq(Xest(:), dPsk(:));
zfdfe_received = pskdemod(Xeqd, M, pi/M);
if sum(isnan(zfdfe_received(:))) == 0
    [~, e] = biterr(zfdfe_received(:), pskdemod(d(:),M,pi/M));
else
    e = 1;
end
end