% decision feedback rls.
% equalize given signal to the original signal, and calculate BER
% nFwdTaps: number of forward taps
% nFdbkTaps: number of feedback taps
% rx: faded signal recieved.
% tx: transmitted modulated signal.
% data: original data transmitted.
% M: current Modulation Scheme.
function [e,y] = my_dfe_rls(nFwdTaps,nFdbkTaps,rx,tx,data,M)
% Initialize Equalizer object.
eq = comm.DecisionFeedbackEqualizer('Algorithm','RLS', ...
        'NumForwardTaps',nFwdTaps,'NumFeedbackTaps',nFdbkTaps, ...
        'ReferenceTap',1);
% Equalize signal.
[y,~,~] = eq(rx(:), tx(:));
% Demodulate equalized signal.
d = pskdemod(y, M, pi/M);
%Calculate BER with regards to original data.
NrNaN = sum(isnan(d(:)));
if NrNaN ~= 0
    e = 1;
else
    [~,e] = biterr(d, data(:));
end

end