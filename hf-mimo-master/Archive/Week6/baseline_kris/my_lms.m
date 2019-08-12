function [e,y] = my_lms(numTaps,stepsz,rx,tx,data,M)
% Initialize Equalizer
eq = comm.LinearEqualizer('Algorithm','LMS', 'NumTaps',numTaps,'ReferenceTap',1,'StepSize',stepsz);
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