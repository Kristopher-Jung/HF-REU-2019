clc;
clear;
M=4;
numSymbols = 1e3; % number of symbols transmitted in total.
lb = [1 4 4 0.0008 0.6 2];
ub = [1 4 4 0.0009 0.7 2];
intvars = [1 2 3 6];
tic
e_min = cognitive_engine_bound(4, 15, lb, ub, intvars)
toc
tic
e_min = cognitive_engine(4, 15)
toc
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
chan = comm.MIMOChannel(...
    'SampleRate',sr,...
    'FadingDistribution','Rayleigh',...
    'AveragePathGains',[0 0],...
    'PathDelays',[0 0.5] * 1e-3,...
    'DopplerSpectrum',doppler('Gaussian', 0.1/2),...
    'TransmitCorrelationMatrix', eye(2), ...
    'ReceiveCorrelationMatrix', eye(2));
data = randi([0 M-1],numSymbols,2); % Initialize random for training.

lookup = [2	5	4	0.000530692	0.987962211	2
    2	6	6	0.00079843	0.987063114	2
    4	4	4	0.000402179	0.988280754	2
    2	6	8	0.00087953	0.987968522	2
    2	6	5	0.000787461	0.987627825	2
    2	5	5	0.000944809	0.988290079	2
    2	6	5	0.000672178	0.988480013	2
    1	6	11	0.000541329	0.988552682	2
    2	6	5	0.000728976	0.988285648	2
    2	5	5	0.000818085	0.988236546	2
    3	7	5	0.000821955	0.987993515	2
    3	4	5	0.000984405	0.987967178	2
    3	5	6	0.00056984	0.988019275	2
    2	6	6	0.000633972	0.988351089	2
    3	5	6	0.000414843	0.987507967	2
    3	4	5	0.000394275	0.989276983	2
    2	6	7	0.000267719	0.988005384	2
    1	7	5	0.00063031	0.988638689	2
    2	7	6	0.000912217	0.98847727	2
    4	9	4	0.000528815	0.988797118	2
    1	6	6	0.000827848	0.988236426	2
    2	6	6	0.000894205	0.988364632	2
    2	6	4	0.000550761	0.988293381	2
    2	5	4	0.00077729	0.987956453	2
    2	5	5	0.000934752	0.989553432	2
    4	12	6	0.000330011	0.987863654	2
    2	8	4	0.000769546	0.987191131	2
    2	14	7	0.000809793	0.98856092	2
    2	6	5	0.000226982	0.988475365	2
    1	5	6	0.000970342	0.98817472	2
    2	6	5	0.000919009	0.988190592	2
    3	6	6	0.000605418	0.9886874	2
    2	7	6	0.000673526	0.986913347	2
    2	6	6	0.000934686	0.988423972	2
    1	7	5	1.96179E-05	0.98795893	2
    1	7	6	0.000270552	0.987984907	3
    2	5	5	0.000634582	0.988905496	2
    2	6	6	0.000891052	0.988383645	2
    4	5	5	0.000235842	0.988129972	2
    2	6	12	0.000777402	0.987329538	2
    2	7	6	0.000231925	0.988434125	2
    2	5	6	0.000827427	0.988129754	2
    2	6	8	0.000835236	0.989452111	2
    2	5	6	0.00035993	0.988218105	2
    4	5	6	0.000810685	0.988688286	2
    2	10	5	0.000813904	0.98918736	2
    2	5	5	0.000629777	0.988436276	2
    2	7	5	0.000861798	0.988326193	2
    4	7	4	0.000854731	0.988246571	2
    2	4	6	0.000910813	0.988124833	2
    1	4	4	0.000937682	0.98986914	3
    4	4	4	0.000402217	0.988280861	1
    2	5	5	0.000561325	0.988058524	2
    1	4	7	0.000905922	0.98865026	3
    2	13	6	8.62341E-05	0.989581776	3
    1	4	8	0.000934876	0.988561338	3
    2	5	5	0.000968538	0.989291199	2
    2	5	5	0.000798501	0.989215276	3
    1	6	6	0.000936889	0.988673077	3
    1	5	4	0.000618873	0.98898981	2];
lookup = [lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;...
    lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;...
    lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;...
    lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;...
    lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;...
    lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;...
    lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;...
    lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;...
    lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;...
    lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup;lookup];
tic
for i=1:60*100
    e(i) = objectiveFunction(data, chan, 4, 15, lookup(i,:));
end
[e_min, ind] = min(e);
display(e_min);
min_config = lookup(ind,:);
display(min_config);
toc
