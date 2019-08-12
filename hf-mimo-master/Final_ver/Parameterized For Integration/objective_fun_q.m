% objective function for q-learning algorithm.
% PARAMATERS
%   - tx: transmitted signal
%   - rx: received signal
%   - M: Modulation
%   - pilot_freq: pilot frequency
%   - params: parameters to be adjusted by q-learning.
%       * window_length: interpolation window. (LS-ZF, LS-MLD)
%       * window_length & var: interpolation window & variation (LS-MMSE)
%           @ window_length lower_bound: 10
%           @ window_length upper_bound: floor(ttlSymbols/10) where
%               ttlSymbols should be size(tx)
%           @ var lower_bound: 10^(-max(snr_range))
%           @ var upper_bound: 10^(min(snr_range))
function BER = objective_fun_q(tx, rx, M, pilot_freq, params)
alg = params(1);
if alg == 1 % LS-ZF
    window_length = params(2);
    [BER, ~] = zf_fun(tx, rx, M, pilot_freq, window_length);
elseif alg == 2 % LS-MLD
    window_length = params(2);
    [BER, ~] = mld_fun(tx, rx, M, pilot_freq, window_length);
elseif alg == 3 % LS-MMSE
    window_length = params(2);
    var = params(3);
    [BER, ~] = mmse_fun(tx, rx, M, pilot_freq, window_length, var);
end
end