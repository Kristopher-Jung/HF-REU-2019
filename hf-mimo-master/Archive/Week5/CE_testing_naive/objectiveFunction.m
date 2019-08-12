% Very Naive version of Objective Function for GA cognitive engines.
% Given data, channel, modulation scheme, run Generative Algorithm to find
% out the best performing set of parameters for DFE equalizers.
% input: inputs that will be trained by CE (specific for GA CE.)
% Assumption: Low SNR/ Low sampling rates (bad ionispheric channel states.)
%               2x2 MIMO Watterson Channel.
function e = objectiveFunction(data, chan, M, SNR, input)
% Initialize DFE params
nFwdTaps = input(1); % Number of forward taps
nFdbkTaps = input(2); % Number of feedback taps
stepsz = input(3); % Step size
alg = input(4); % Algorithm Choice

% Input Modulation.
tx = pskmod(data(:), M, pi/M);

% Fading through Watterson Channel and AWGN Channel.
rx = chan(tx);
rx = awgn(rx, SNR);

% Equalize and get error rate.
if alg == 1 % Least Squares + Zero Forcing
    H_est=pinv(tx)*rx;
    y=rx/H_est;
    d = pskdemod(y, M, pi/M);
    [~,e] = biterr(d, data(:));
elseif alg == 2 % DFE LMS
    eq = comm.DecisionFeedbackEqualizer('Algorithm','LMS', ...
        'NumForwardTaps',nFwdTaps,'NumFeedbackTaps',nFdbkTaps,'ReferenceTap',1, ...
        'StepSize',stepsz);
    [y,~,~] = eq(rx, tx(1:1000));
    d = pskdemod(y, M, pi/M);
    [~,e] = biterr(d, data(:));
elseif alg == 3 % DFE RLS
    eq = comm.DecisionFeedbackEqualizer('Algorithm','RLS', ...
        'NumForwardTaps',nFwdTaps,'NumFeedbackTaps',nFdbkTaps, ...
        'ReferenceTap',1);
    [y,~,~] = eq(rx, tx(1:1000));
    d = pskdemod(y, M, pi/M);
    [~,e] = biterr(d, data(:));
end