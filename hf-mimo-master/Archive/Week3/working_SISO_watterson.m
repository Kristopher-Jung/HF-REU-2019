clear all;

%code from https://www.mathworks.com/help/comm/ref/comm.linearequalizer-system-object.html#
M = 4; % QPSK
numSymbols = 1000000;
numTrainingSymbols = 1000;
chtaps = [1 0.5*exp(1i*pi/6) 0.1*exp(-1i*pi/8)];

errorRate = comm.ErrorRate;

data = randi([0 M-1],numSymbols,1);
tx = pskmod(data,M,pi/4);

wat = stdchan('iturHFMQ',20e6,1);

rx = wat(tx);
rx = awgn(filter(chtaps,1,rx),25,'measured');

eq = comm.LinearEqualizer; 
eq.ReferenceTap = 1;
mxStep = maxstep(eq,rx); 

[y,err,weights] = eq(rx,tx(1:numTrainingSymbols));

%constell = comm.ConstellationDiagram('NumInputPorts',2);
%constell(rx,y);

final = pskdemod(y,M,pi/4);

errors = errorRate(data, final);
fprintf('\nSymbol error rate = %d from %d errors in %d symbols\n',errors)