% ber_ce_ga is returning the lowest bit error rate of optimized equalizers.
function [ber, eq] = ber_ce_ga(tx, rx, M, pilot_freq, snr_range)
bers = [ga_mmse(tx, rx, M, pilot_freq, snr_range), ...
    ga_zf_mld(tx, rx, M, pilot_freq, 1),...
    ga_zf_mld(tx, rx, M, pilot_freq, 2)]; % accumulating ber results from GA
[ber, idx] = min(bers); % locate the lowest ber
if idx == 1 % returning the name of the equalizer chosen.
    eq='ZF';
elseif idx == 2
    eq='MLD';
elseif idx == 3
    eq='MMSE';
end
end