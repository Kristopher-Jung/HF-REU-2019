function graphing(legend_labels, SNRs, BERs, syms_per_Tx, nTx, M)
%GRAPHING funciton to display all the relvant graphs:
%   - BER (bit error ratio)
%   - spectral efficiency
%   - rates
%
%PARAMETERS:
%   - legend_labels = cell array with the titles of each set of data to graph
%   - SNRs = column vector of SNRs for which we want to display values
%   - BERs = matrix of BERs. Should be of the size (# data sources = size(legend)) x (# SNRs)
%   - syms_per_Tx = number of symbols transmitted per antenna
%   - nTx = number of transmit antennas
%   - M = PSK modulation degree

data_sources = numel(legend_labels); % the number of different data input sources to graph
markers = ['+','o','*','x','s','d','p','h']; %possible line markers to use
colors = ['k','r','g','b','m','c','y','w'];

%% graph BERs
figure
subplot(2,2,[1 2])
hold on
for data_source = 1:data_sources
    plot(SNRs, BERs(data_source,:),strcat('-',markers(mod(data_source,length(markers)) + 1),colors(mod(data_source,length(colors)) + 1))); 
end
axis auto
title("BERs");
grid on
xlabel("SNR, dB"); 
ylabel("Bit Error Ratio (BER)");
legend(legend_labels); 
hold off

%% graph rates
% calculate rates
calculate_rate = @(ber) ((1 - ber) * syms_per_Tx * nTx * M); 
rates = arrayfun(calculate_rate, BERs); 

% perform graphing
subplot(2,2,3)
hold on
for data_source = 1:data_sources
    semilogy(SNRs, rates(data_source,:),strcat('-',markers(mod(data_source,length(markers)) + 1),colors(mod(data_source,length(colors)) + 1))); 
end
title("Rates");
xlabel("SNR, dB"); 
ylabel("Data Rate (bits/s)");
legend(legend_labels, 'location', 'southeast'); 
grid on;
hold off

%% graph spectral efficiency
% calculate spectral efficiency
calculate_efficiency = @(rate) rate / syms_per_Tx; 
spec_efficiency = arrayfun(calculate_efficiency, rates);


% perform graphing
% plot a separate graph for each SNR/BER combo
% (this will be an absurd number of graphs, but putting them in the same
%   graph would be illegibly busy. Possibly add some sort of selector here?)
subplot(2,2,4)
hold on
for data_source = 1:data_sources
    plot(SNRs,spec_efficiency(data_source,:),strcat('-',markers(mod(data_source,length(markers)) + 1),colors(mod(data_source,length(colors)) + 1))); 
end
title("Spectral Efficiency");
xlabel("SNR, dB"); 
ylabel("Spectral Efficiency, (b/s)/Hz");
legend(legend_labels, 'location', 'southeast'); 
grid on;
hold off
end