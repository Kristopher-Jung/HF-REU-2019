% decision feedback lms.
% equalize given signal to the original signal, and calculate BER
% nFwdTaps: number of forward taps
% nFdbkTaps: number of feedback taps
% stepsz: step size.
% rx: faded signal recieved.
% tx: transmitted modulated signal.
% data: original data transmitted.
% M: current Modulation Scheme.
function [e,y] = my_dfe_lms(nFwdTaps,nFdbkTaps,stepsz,rx,tx,data,M)
% Initialize Equalizer
eq = comm.DecisionFeedbackEqualizer('Algorithm','LMS', ...
    'NumForwardTaps',nFwdTaps,'NumFeedbackTaps',nFdbkTaps,'ReferenceTap',1, ...
    'StepSize',stepsz);
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