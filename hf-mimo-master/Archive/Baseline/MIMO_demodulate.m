% a function to perform all demodulation of the signal in one function
% variables:
%   - Rx = data to demodulate (received signal)
%   - modulation = indicator of which modulation scheme to use
%   - M = order of PSK modulation
%   - nRx = number of receiving antennas
%   - nFrames = number of frames
%   - modulator = comm.OFDMModulator object used to modulate data

%default call: modulate(data, 'none', 2, 2, 1000, modulator); 
function demodulated = MIMO_demodulate(Rx, modulation, M, nRx, nFrames, modulator)

%case where modulation happens outside
if strcmp(modulation, 'OFDM')
    
    %calculate frame length
    frame_length = length(Rx) / nFrames; 
    
    ofdmDemod = comm.OFDMDemodulator(modulator);
    ofdmDemod.NumReceiveAntennas = nRx; 
    demodDim = info(ofdmDemod); 
    
    x = demodDim.DataOutputSize;
    
    psk_signal = zeros(demodDim.DataOutputSize(1) * nFrames, demodDim.DataOutputSize(3));
    
    %for each frame
    for k = 1:nFrames
            psk_signal(demodDim.DataOutputSize(1) * (k-1) + 1:demodDim.DataOutputSize(1) * k,:) = ofdmDemod(Rx(frame_length * (k - 1) + 1:frame_length * k,:));
    end

    Rx = pskdemod(psk_signal, M);
    
elseif strcmp(modulation, 'none')
    %demodulate PSK modulation only
    Rx = pskdemod(Rx, M);
end

%return the modulated value
demodulated = Rx;
end