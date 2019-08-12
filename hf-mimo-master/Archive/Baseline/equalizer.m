% run each of several equalizers on the data. 
% Parameters:
%   - equalizer_type = what equalizer to use. Unused right now, all
%   equalizers are used
%   - Rx = received signal
%   - Tx = originally transmitted data, to use for training
%   - M = modulation degree. Used for generation of a constellation
%   - training_size = how many symbols to use from Tx to train the data set
%   on. If training_size = 0, the program will default to using the first
%   tenth of the transmitted data set. 

function [linear,dfe,raw] = equalizer(equalizer_type, Rx, Tx, M, training_size)

% extract selection of data to be used to train the equalizers. By default,
% the first tenth of the data set will be used
if training_size == 0
    training = Tx(1:round(length(Tx) / 10),:); 
else
    training = Tx(1:round(training_size),:);
end
% Linear equalizer parameters
nWts = 2;               % number of weights
algType = 'RLS';         % RLS algorithm
forgetFactor = 0.999999; % parameter of RLS algorithm

constellation_data = 0:M - 1;
const = pskmod(constellation_data, M, pi/M); 

linEq = comm.LinearEqualizer('Algorithm', algType, ... 
    'ForgettingFactor', forgetFactor, 'NumTaps', nWts, ...
    'Constellation', const, 'ReferenceTap', 1);

% DFE parameters - use same update algorithms as linear equalizer
nFwdWts = 4;            % number of feedforward weights
nFbkWts = 4;            % number of feedback weights

dfeEq = comm.DecisionFeedbackEqualizer('Algorithm', algType, ...
  'ForgettingFactor', forgetFactor, 'NumForwardTaps', nFwdWts, ...
  'NumFeedbackTaps', nFbkWts, 'Constellation', const, ...
  'ReferenceTap', 1);
    

%perform linear equalization on each half of the data separately, then
%recombine it
linear = cat(2, linEq(Rx(:,1), training(:,1)), linEq(Rx(:,2), training(:,2))); 
%apply the DFE to each half of the data separately, then
%recombine it
dfe = cat(2, dfeEq(Rx(:,1), training(:,1)), dfeEq(Rx(:,2), training(:,2)));
%simply return the input received signal
raw = Rx; 

end