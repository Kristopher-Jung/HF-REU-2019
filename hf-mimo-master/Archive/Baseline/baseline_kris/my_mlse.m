% mlse equalizer.
% Channel: estimated channel by Least Square
% Constellation: reference constellation of current modulation scheme.
% M: current modulation scheme.
% rx: faded received signal.
% data: original transmitted signal.
% TracebackDepth: number of traceback.
function [e,y] = my_mlse(Channel,Constellation,M,rx,data,TracebackDepth)
% Initialize mlse equalizer.
mlse = comm.MLSEEqualizer('TracebackDepth',TracebackDepth,...
    'Channel',Channel,'Constellation',Constellation);
% equlize signal.
y = mlse(rx);
% demodulate equalized signal.
d = pskdemod(y, M, pi/M);
% calculate BER with regards to orignal data.
[~,e] = biterr(d, data(:));
end