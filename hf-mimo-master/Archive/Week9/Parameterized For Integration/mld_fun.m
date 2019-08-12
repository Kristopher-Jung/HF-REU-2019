% ML detector function. Returns, in order, equalized data and BER (bit error ratio)
%
% PARAMETERS
%   - Tx = signal before transmission
%   - Rx = received signal
%   - window_length = number of timesteps to average channel estimates over
%   - pilot_freq = frequency of symbols with known Tx symbol
%   - M = modulation order
%default function call: mld_fun(Tx, Rx, 10, 2,  M)
function [BER, detected] = mld_fun(Tx, Rx, M, pilot_freq, window_length)
[ttlSymbols, nTx] = size(Tx);% getter transmission size variables
H_est = ls_interpolate_fun(Tx, Rx, pilot_freq, window_length);% interpolated channel estimation.
detected = zeros(ttlSymbols, nTx); % allocation for speed
for j = 1:ttlSymbols % mld detector begins
    
    % create a dictionary of all possible received symbol orderings
    syms = 0:M-1; 
    dict = permn(syms, nTx); 
    dict = pskmod(dict,M,pi/M);
    
    [nperms, ~] = size(dict); 
    
    mu = nan(nperms,1);
    
    % determine the weights of each possible symbol sequence to have been
    % received
    for i = 1:nperms
        mu(i) = sum(abs(Rx(j,:) - dict(i,:)*squeeze(H_est(j,:,:))).^2);
    end

    [~, idx] = min(mu); % get minimum
    detected(j,:,:) = dict(idx,:); % closest point.
    
end
[~, BER] =  biterr(pskdemod(detected(:),M,pi/M),pskdemod(Tx(:),M,pi/M));
end