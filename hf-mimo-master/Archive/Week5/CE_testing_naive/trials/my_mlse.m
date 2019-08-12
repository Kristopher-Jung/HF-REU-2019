function e = my_mlse(Channel,Constellation,M,rx,data,TracebackDepth)
mlse = comm.MLSEEqualizer('TracebackDepth',TracebackDepth,...
    'Channel',Channel,'Constellation',Constellation);
y = mlse(rx);
d = pskdemod(y, M, pi/M);
[~,e] = biterr(d, data(:));
end