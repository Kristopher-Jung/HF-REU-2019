% zero-forcing function. Returns, in order, equalized data, channel
% estimate, and BER (bit error ratio)
%
% PARAMETERS
%   - Tx = signal before transmission
%   - Rx = received signal
%   - window_length = how many values to average over
%   - pilot_freq = how frequently ZF calculates a new pilot value
%   - M = modulation order

%default function call: zf_fun(Tx, Rx, 10, 2, M)
function [BER, y] = zf_fun(Tx, Rx, M, pilot_freq, window_length)
[ttlSymbols, nTx] = size(Tx); % getter transmission size variables
y = zeros(ttlSymbols, nTx); % allocation for speed
H_est = ls_interpolate_fun(Tx, Rx, pilot_freq, window_length);% interpolated channel estimation.
for i=1:ttlSymbols % Zero Forcing begins
    y(i,:) = Rx(i,:)*pinv(squeeze(H_est(i,:,:)));
end

[~, BER] =  biterr(pskdemod(y(:),M,pi/M),pskdemod(Tx(:),M,pi/M));
end