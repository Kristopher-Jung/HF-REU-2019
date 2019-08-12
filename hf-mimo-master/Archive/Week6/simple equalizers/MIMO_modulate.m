% a function to perform all modulation of the signal in one function
% variables:
%   - data = data to modulate
%   - modulation = indicator of which modulation scheme to use
%   - M = order of PSK modulation
%   - nTx = number of transmitting antennas
%   - frame_length = size of a single frame (note: 2^FFT = frame_lengt, otherwise things start breaking right now)
%   - FFT_power = degree of the number of subcarriers (FFT_power 6 => 64 subcarriers)

%default call: modulate(data, 'none', 2, 2, 256, 6); 
function [modulated, modulator] = MIMO_modulate(data, modulation, M, nTx, frame_length, FFT_power)

%case where modulation happens outside
if strcmp(modulation, 'OFDM')
    nFrames = length(data) / frame_length;
    
    % create OFDM modulator object
    ofdmMod = comm.OFDMModulator('FFTLength',2^FFT_power,'NumGuardBandCarriers', [0;0], 'NumTransmitAntennas',nTx);%'PilotInputPort',true,'InsertDCNull',true
    modDim = info(ofdmMod);
    numData = modDim.DataInputSize(1);   % Number of data subcarriers, is equal to FFTLength when all nulls are removed
    numSym = modDim.DataInputSize(2);    % Number of OFDM symbols
        
    modData = pskmod(data(:), M); % modulate data with PSK order specified
    modData = reshape(modData,nFrames * numData,numSym,nTx); % reshape data for channel compatibility
    
    Tx = zeros(modDim.OutputSize(1) * nFrames, modDim.OutputSize(2));
    
    %encode each frame
    for k = 1:nFrames
        % determine the indices in modData where this frame of data will be
        dataIdx = (k-1) * numData + 1:k * numData; 
        
        % apply OFDM modulation to the selected data frame
        initial_data = modData(dataIdx,:,:);
        Tx(modDim.OutputSize(1) * (k - 1) + 1:modDim.OutputSize(1) * k,:) = ofdmMod(initial_data);%, pilotData);
    end
    
    modulator = ofdmMod;             
elseif strcmp(modulation, 'none')
    %just apply PSK modulation
    Tx = pskmod(data, M);
    modulator = 'none';
end

%return the modulated value
modulated = Tx;
end