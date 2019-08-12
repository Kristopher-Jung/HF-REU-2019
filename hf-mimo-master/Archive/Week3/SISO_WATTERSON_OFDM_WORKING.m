clear;
clc;

% Create Random Data for QPSK Modulation.
M = 4;
numSymbols = 10000;
data = randi([0 M-1],numSymbols,1);

% Create a QPSK modulator and demodulator pair
qpskMod = comm.QPSKModulator;
qpskDemod = comm.QPSKDemodulator;

% Create an error rate counter
errorRate = comm.ErrorRate;

% Initialize LMS Equalizer Object
eqlms = comm.LinearEqualizer;
eqlms.ReferenceTap = 1;
    
% Apply QPSK modulation to the random symbols
Tx = qpskMod(data);

% Apply OFDM modulation to the random symbols
ofdmMod = comm.OFDMModulator('FFTLength',10016,'PilotInputPort',true,...
    'InsertDCNull',true,...
    'NumTransmitAntennas',1);
ofdmDemod = comm.OFDMDemodulator(ofdmMod);
ofdmDemod.NumReceiveAntennas = 1;
ofdmModDim = info(ofdmMod);
numData = ofdmModDim.DataInputSize(1);   % Number of data subcarriers
numSym = ofdmModDim.DataInputSize(2);    % Number of OFDM symbols
numTxAnt = 1;  % Number of transmit antennas
pilotData = complex(rand(ofdmModDim.PilotInputSize), ...
        rand(ofdmModDim.PilotInputSize));
Tx = ofdmMod(Tx, pilotData);


% Initialize Watterson Channel
wattersonChan = stdchan('iturHFMQ',20e6,1);

% Apply watterson channel
Tx = wattersonChan(Tx);
    
% Apply AWGN Channel
Rx = awgn(Tx,30,'measured');
    
% Apply LMS to remove effects of fading channels
rxSigMF = eqlms(Rx, Tx);

% Demodulate OFDM.
rxSigMF = ofdmDemod(rxSigMF);

% Demodulate QPSK data
receivedData = step(qpskDemod,rxSigMF); 

% Compute error statistics
errors = errorRate(data,receivedData);

% Print error message
fprintf('\nSymbol error rate = %d from %d errors in %d symbols\n',errors)



