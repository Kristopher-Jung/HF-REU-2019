%Create a QPSK modulator and demodulator pair
qpskMod = comm.QPSKModulator;
qpskDemod = comm.QPSKDemodulator;
%Create an OFDM modulator and demodulator pair with user-specified pilot
%indices, an inserted DC null, two transmit antennas, and two receive
%antennas. Specify pilot indices that vary across antennas.
ofdmMod = comm.OFDMModulator('FFTLength', 128, 'PilotInputPort', true,...
    'PilotCarrierIndices', cat(3,[12;40;54;76;90;118],...
    [13;39;55;75;91;117]), 'InsertDCNull', true, ...
    'NumTransmitAntennas',2);
ofdmDemod = comm.OFDMDemodulator(ofdmMod);
ofdmDemod.NumReceiveAntennas = 2;
%showResourceMapping(ofdmMod) 
%Show the resource mapping of pilot
%subcarriers for each transmit antenna. The gray lines in the figure denote
%the insertion of null subcarriers to minimize pilot signal interference.

ofdmModDim = info(ofdmMod); %determine the dimensions of the OFDM modulator by using the info method
numData = ofdmModDim.DataInputSize(1); %Number of data subcarriers
numSym = ofdmModDim.DataInputSize(2); %Number of OFDM symbols
numTxAnt = ofdmModDim.DataInputSize(3); %Number of transmit antennas
nframes = 100;
data = randi([0 3],nframes*numData,numSym,numTxAnt); %Generate data symbols to fill 100 OFDM frames

%Apply QPSK modulation to the random symbols and reshape the resulting
%column vector to match the OFDM modulator requirements.
modData = qpskMod(data(:));
modData = reshape(modData,nframes*numData,numSym,numTxAnt);
errorRate = comm.ErrorRate;%create an error rate counter

mimochannel = comm.MIMOChannel(...
    'SampleRate',100, ...
    'PathDelays',[0 2e-3], ...
    'AveragePathGains',[0 -5], ...
    'MaximumDopplerShift',10, ...
    'SpatialCorrelationSpecification','None', ...
    'NumTransmitAntennas',2, ...
    'NumReceiveAntennas',2);

for k = 1:nframes

    % Find row indices for kth OFDM frame
    indData = (k-1)*ofdmModDim.DataInputSize(1)+1:k*numData;

    % Generate random OFDM pilot symbols
    pilotData = complex(rand(ofdmModDim.PilotInputSize), ...
        rand(ofdmModDim.PilotInputSize));

    % Modulate QPSK symbols using OFDM
    dataOFDM = ofdmMod(modData(indData,:,:),pilotData);

    %%%
    
    rxSig = mimochannel(dataOFDM);
    
    %%%
    % Pass OFDM signal through Rayleigh and AWGN channels
    receivedSignal = awgn(dataOFDM*chGain,30);

    % Apply least squares solution to remove effects of fading channel
    rxSigMF = chGain.' \ receivedSignal.';

    % Demodulate OFDM data
    receivedOFDMData = ofdmDemod(rxSigMF.');

    % Demodulate QPSK data
    receivedData = qpskDemod(receivedOFDMData(:));

    % Compute error statistics
    dataTmp = data(indData,:,:);
    errors = errorRate(dataTmp(:),receivedData);
end
fprintf('\nSymbol error rate = %d from %d errors in %d symbols\n',errors)




