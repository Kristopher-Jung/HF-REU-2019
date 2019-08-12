% MMSE equalizer function. Returns, in order, equalized data and BER (bit error ratio)
%
% PARAMETERS
%   - Tx = signal before transmission
%   - Rx = received signal
%   - H_est = estimate of H produced by ZF (or other means)
%   - M = modulation order
%   - var = variance (SNR)

%default function call: mmse_fun(Tx, Rx, H_est, M, var)
function [BER, detected] = mmse_fun(Tx, Rx, M, pilot_freq, window_length, var)
[ttlSymbols, nTx] = size(Tx);% getter transmission size variables
[~, nRx] = size(Rx);% getter reciver size variables.
H_est = ls_interpolate_fun(Tx, Rx, pilot_freq, window_length);% interpolated channel estimation.
detected = zeros(ttlSymbols, nTx); % allocation for speed
for i = 1 : ttlSymbols % mmse begins
    H_temp = squeeze(H_est(i,:,:));
    W = [];
    for nr = 1 : nRx
        w = (H_temp*H_temp' + var*eye(nTx))^(-1)*H_temp(:,nr);
        W = [W w];
    end
    detected(i,:) = Rx(i,:)*pinv(W);
end

[~, BER] =  biterr(pskdemod(detected(:),M,pi/M),pskdemod(Tx(:),M,pi/M));
end