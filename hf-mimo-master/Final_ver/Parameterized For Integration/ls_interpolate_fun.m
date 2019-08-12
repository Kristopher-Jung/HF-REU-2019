% Channel interpolating function. Returning interpolated channel estimation
% matrix assuming the given pilot frequency and window length.
%
% PARAMETERS
%   - Tx = transmitting signal
%   - Rx = received signal
%   - pilot_freq = pilot frequency
%   - window_length = window length

function H_est = ls_interpolate_fun(Tx, Rx, pilot_freq, window_length)
[ttlSymbols, nTx] = size(Tx);% getter transmission size variables
[~, nRx] = size(Rx);% getter reciver size variables.
H_est= zeros(ttlSymbols, nTx,nRx); % allocation for speed.
% LEAST SQUARE CHANNEL ESTIMATION
for i=1:ttlSymbols
    if(mod(i-1,pilot_freq)==0)
        H_est(i,:,:)=pinv(Tx(i,:))*Rx(i,:);
    end
end
for i=1:window_length:ttlSymbols % interpolation begins
    numrefs = 0;
    H_est_temp = zeros(nTx, nRx);
    % compute for all H_est frames in the window that are nonzero (i.e.
    % have been assigned from pilots)
    for j = i:min(i+window_length - 1,ttlSymbols)
        if sum(sum(H_est(j,:,:))) ~= 0
            H_est_temp = H_est_temp + squeeze(H_est(j,:,:));
            numrefs = numrefs + 1;
        end
    end
    H_est_temp = H_est_temp / numrefs;
    % assign H_estimate for all timesteps in the window
    for j=i:min(i+window_length, ttlSymbols)
        if sum(sum(H_est(j,:,:))) == 0
            H_est(j,:,:)=H_est_temp;
        end
    end
end
end