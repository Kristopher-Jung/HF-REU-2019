% Input Params:
%   snr = signal to noise ratio
%   samp_rate = sampling rate
%   nReceive = number of reciving antennas
%   nTransmit = number of transmitting antennas (nReceive >= nTransmit)
%   signal_power = power of signal from transmitters
%   PSK_order = order of Modulations (BPSK(2), QPSK(4), ....)
%   nframes = number of frames
%   FFT_len_power = FFT length (power of 2, 2^(x), x >= 5)
%   Algorithm = [LS_ZF, LMS, RLS, CMA]
%   num_fts = number of forward taps.
%   num_fbts = number of feed back taps.
%   step_size = number of steb sizes to be used for LMS
%   RT = Number of reference tab to be used for equalizers
% Output Measurments:
%   E: error per each transmitting antennas
%   P: Average Power Gains at each of Receivers
%   C: Capacity of the current systems
%   EVM: Error Vector Magnitutde
function [E, P, C, EVM] = MIMO_PARAMATIZED_FUNC(...
    data, chan, snr, ...
    nTransmit, nReceive, ...
    signal_power, PSK_order_power, nframes, FFT_len_power, ...
    Algorithm, num_fts, num_fbts, step_size, RT, FF)

% verify inputs
mustBeGreaterThan(FF, 0);
mustBeLessThanOrEqual(FF, 1);
mustBeGreaterThan(step_size, 0);
mustBeGreaterThanOrEqual(FFT_len_power,5);
mustBeGreaterThanOrEqual(nReceive,nTransmit);
mustBeGreaterThanOrEqual(signal_power, 1);
mustBeGreaterThanOrEqual(snr, 1);
mustBeGreaterThanOrEqual(PSK_order_power, 1);
mustBeGreaterThan(num_fts, 1);
mustBeGreaterThan(num_fbts, 1);
mustBeGreaterThanOrEqual(RT, 1);
PSK_order = 2^PSK_order_power;

% Initialize AWGN Channel.
awgn = comm.AWGNChannel(...
    'EbNo',snr,...
    'BitsPerSymbol',log2(PSK_order),...
    'SignalPower', signal_power);

% Initialize EVM
evm = comm.EVM(...
    'MaximumEVMOutputPort',true,...
    'XPercentileEVMOutputPort',true,...
    'XPercentileValue',90,...
    'SymbolCountOutputPort',true);

% Apply OFDM modulation to the random symbols
ofdmMod = comm.OFDMModulator(...
    'FFTLength',2^FFT_len_power,...
    'PilotInputPort',true,...
    'NumTransmitAntennas',nTransmit);

% Initialize OFDM Demodulator
ofdmDemod = comm.OFDMDemodulator(ofdmMod);
ofdmDemod.NumReceiveAntennas = nTransmit;
ofdmModDim = info(ofdmMod);
numData = ofdmModDim.DataInputSize(1);   % Number of data subcarriers
numSym = ofdmModDim.DataInputSize(2);    % Number of OFDM symbols

% Modulate Data
modData = pskmod(data(:), PSK_order);
modData = reshape(modData,nframes*numData,numSym,nTransmit);

% Choosing the right DFE equalizer
switch Algorithm
    case 'LMS'
        eq = comm.DecisionFeedbackEqualizer('Algorithm','LMS', ...
            'NumForwardTaps',num_fts,'NumFeedbackTaps',num_fbts,'StepSize',step_size, 'ReferenceTap', RT);
    case 'RLS'
        eq = comm.DecisionFeedbackEqualizer('Algorithm','RLS', ...
            'NumForwardTaps',num_fts,'NumFeedbackTaps',num_fbts,...
            'ReferenceTap', RT, 'ForgettingFactor', FF);
    case 'CMA'
        eq = comm.DecisionFeedbackEqualizer('Algorithm','CMA', ...
            'NumForwardTaps',num_fts,'NumFeedbackTaps',num_fbts,'StepSize',step_size, 'ReferenceTap', RT);
    case 'LS_ZF'
        eq = 'dummy';
end

P = 0;
for k = 1:nframes
    % Find row indices for kth OFDM frame
    indData = (k-1)*ofdmModDim.DataInputSize(1)+1:k*numData;
    
    % Generate random OFDM pilot symbols
    pilotData = complex(rand(ofdmModDim.PilotInputSize), ...
        rand(ofdmModDim.PilotInputSize));
    
    % Modulate QPSK symbols using OFDM
    initial_data = modData(indData,:,:);
    Tx = ofdmMod(initial_data, pilotData);
    
    % Applying MIMO Channel Fading in Watterson Setup
    Rx = chan(Tx);
    
    % Applying AWGN Channel Fading
    Rx = awgn(Rx);
    
    % Picking right Algorithm for equalization
    [H_est, tx_est] = eqz(eq, Algorithm, Rx, Tx);
    
    % Demodulate OFDM data
    receivedOFDMData = ofdmDemod(tx_est);
    
    % Calculate EVM
    [rmsEVM,~,~,~] = evm(initial_data,receivedOFDMData);
    for i = 1:nTransmit
        EVMs(i) = rmsEVM(:,:,i);
    end
    EVM(k) = min(EVMs);
    
    % Demodulate PSK data
    receivedData = cell(1, nTransmit);
    for i = 1:nTransmit
        receivedData{i} = pskdemod(receivedOFDMData(:,i), PSK_order);
    end
    
    % Compute error statistics
    dataTmp = data(indData,:,:);
    for i = 1:nTransmit
        errorRate = comm.ErrorRate;
        errors = errorRate(dataTmp(:,:,i), receivedData{i});
        err(i) = errors(1);
    end
    e(k) = min(err);
    % Calculating mean Power of the received signals at each Receiver.
    for i = 1:nReceive
        P = P + mean(20*log10(abs(Rx(:,i))));
    end
end
% Calculate mean error rate, mean EVM, mean Power Gain for this system.
EVM = mean(EVM);
E = min(e);
P = P/nframes;

% Calculating Capaity.
N = min(nReceive, nTransmit);
[~, V, ~] = svd(H_est*H_est');
C = 0;
for k=1:N
    lamda(k) = V(k,k);
    C = C + log2(1+snr*lamda(k)/nTransmit);
end





