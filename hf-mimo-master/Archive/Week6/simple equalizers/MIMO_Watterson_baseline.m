% baseline, simple MIMO-Watterson channel implementation
% with no CE/Machine Learning implementations

% quick change values (modify system parameters for various testing needs)
clear all
clc
close all 

%program preferences
verbose = true; % for verbose = true print out statements designating where in the program run we are
constellation_visualizer = false; % for true, the constellations will be shown for each loop
BER_graph = true; % output SNR vs. BER graph if this is true

% default physical system values
nTx = 2; % number of transmit antennas
nRx = nTx; % number of receive antennas
SNR = 10:2:20; % Signal-to-Noise Ratio
chan = 'Manual Rayleigh'; % chan controls what channel the signal is transmitted through, 'Watterson', 'Rayleigh', 'Manual Rayleigh', 'AWGN', 'none'

% default modulation controls
M = 4; % default modulation order
modulation = 'none'; % if modulation = 'OFDM', the signal will be OFDM-Encoded, if modulation = 'none' it will be plain PSK encoded
FFT_power = 8; % exponent on 2 for number of subcarriers used by OFDM encoding

% transmission controls
%NOTE: these are no longer used but are still here in case we re-integrate OFDM. Use nSyms instead. 
nFrames = 10000; % number of frames to transmit (i.e. number of frames for which to apply/evaluate the model)
frame_length = 2^FFT_power; % length of each frame to be sent via OFDM. Higher frame length will give better training to a CE model. Make it FFT_power for ease

nSyms = 100000; % how many symbols to send for each test iteration

%main program begins here
BERs = zeros(length(SNR),3,1); %eventually, store BERs for each SNR

% perform a simulation for each SNR
for idx = 1:length(SNR)
    snr = SNR(idx); % the actual SNR being used
    
    if verbose
        fprintf('SNR: %d \n', snr); 
    end
    
    % CREATE AND MODULATE DATA TO TRANSMIT
    if verbose
        fprintf('Creating and modulating data... \n');
    end
    
    % transmission signal
%    data = randi([0 M-1],nFrames * frame_length, nTx); % generate a set of data with nFrames * frame_length symbols per Tx antenna in an array
    data = randi([0 M-1],nSyms, nTx); % generate a set of data
    
    %perform modulations
%    [Tx, modulator] = MIMO_modulate(data, modulation, M, nTx, frame_length, FFT_power);
    Tx = pskmod(data, M, pi/M);
    
    % PERFORM TRANSMISSION
    if verbose
        fprintf('Simulating transmission... \n'); 
    end
    
    Rx = MIMO_transmit(Tx, snr, chan, nTx, nRx);
    
    % PERFORM EQUALIZATION AND CHANNEL ESTIMATION
    if verbose
        fprintf('Performing equalization and estimation...\n'); 
    end
    % call all equalizer implementations
    [linear, dfe, raw] = equalizer('all', Rx, Tx, M, length(Tx) / 6);
    
    % DEMODULATE DATA, EVALUATE PERFORMANCE
    if verbose
        fprintf('Demodulating data... \n');
    end
    
%    received_data = MIMO_demodulate(Rx, modulation, M, nRx, nFrames, modulator);
%    received_data = pskdemod(Rx, M);    
%    %evaluate returned data
%    [e, BER] = MIMO_eval(received_data, data); 
%    BERs(idx,1) = BER; 

    linear_received = pskdemod(linear, M, pi/M);    
    [e, BER] = MIMO_eval(linear_received, data); 
    BERs(idx,1) = BER; 
    
    dfe_received = pskdemod(dfe, M, pi/M);
    [e, BER] = MIMO_eval(dfe_received, data); 
    BERs(idx,2) = BER; 
    
    raw_received = pskdemod(Rx, M, pi/M);
    [e,BER] = MIMO_eval(raw_received, data); 
    BERs(idx,3) = BER; 

    if constellation_visualizer
        constdiag = comm.ConstellationDiagram(2,'ChannelNames',{'linear', 'dfe'},'Name', 'constellation','ShowLegend', true, 'ReferenceConstellation',pskmod(0:(M-1), M, pi/M)); 
        constdiag(cat(1, linear(:,1), linear(:,2)), cat(1, dfe(:,1), dfe(:,2)));
    end
end
if verbose
    fprintf("Simulation finished, generating graphics...\n");
end

% FORMAT AND OUTPUT ANALYSIS

%output graph displaying outputs
if BER_graph
    figure
    hold on
    semilogy(SNR, BERs(:,1), '-ob', 'LineWidth', 2);
    semilogy(SNR, BERs(:,2), '-sg', 'LineWidth', 2);
    semilogy(SNR, BERs(:,3), '-or', 'LineWidth', 2);
    grid on
    legend('Linear Equalization', 'DFE', 'no equalizer');
    xlabel('Average Eb/No, dB');
    ylabel('Bit Error Rate');
    title('BER modulation 2x2 MIMO');
end

if verbose
    fprintf("Average BER: %f \n", mean(BERs));
end
