function [e,y] = my_rls(numTaps,rx,tx,data,M)
% Initialize Equalizer
eq = comm.LinearEqualizer('Algorithm','RLS', 'NumTaps',numTaps,'ReferenceTap',1);
% Equalize signal.
[y,~,~] = eq(rx(:), tx(:));
%Demodulate equalized signal.
d = pskdemod(y, M, pi/M);
% calculated BER with regards to original data.
NrNaN = sum(isnan(d(:)));
if NrNaN ~= 0
    e = 1;
else
    [~,e] = biterr(d, data(:));
end
end