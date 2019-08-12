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

Rs = 9.6e3; % Channel Sampling rate
M = 4; % Modulation Order QPSK
fd = 10; % Chosen Maximum Doppler Shift for simulation
sGauss1 = 2.0;
fGauss1 = -5.0;
dopplerComp1 = doppler('BiGaussian',...
    'NormalizedStandardDeviations', [sGauss1/fd 1/sqrt(2)],...
    'NormalizedCenterFrequencies', [fGauss1/fd 0],...
    'PowerGains', [0.5 0]);

chanComp1 = comm.RayleighChannel( ...
    'SampleRate',          Rs, ...
    'MaximumDopplerShift', fd, ...
    'DopplerSpectrum',     dopplerComp1, ...
    'RandomStream',        'mt19937ar with seed', ...
    'Seed',                99, ...
    'PathGainsOutputPort', true);

sGauss2 = 1.0;
fGauss2 = 4.0;
dopplerComp2 = doppler('BiGaussian', ...
    'NormalizedStandardDeviations', [sGauss2/fd 1/sqrt(2)], ...
    'NormalizedCenterFrequencies',  [fGauss2/fd 0], ...
    'PowerGains',                   [0.5        0]);

chanComp2 = comm.RayleighChannel( ...
    'SampleRate',          Rs, ...
    'MaximumDopplerShift', fd, ...
    'DopplerSpectrum',     dopplerComp2, ...
    'RandomStream',        'mt19937ar with seed', ...
    'Seed',                999, ...
    'PathGainsOutputPort', true);

gGauss1 = 1.2;       % Power gain of first component
gGauss2 = 0.25;      % Power gain of second component
frmLen = ofdmMod.FFTLength+ofdmMod.CyclicPrefixLength;
Ns = frmLen*nframes;
[y, g] = deal(zeros(Ns, 2));

%Simulate the OFDM system over 100 frames assuming a flat, 2x2, Rayleigh
%fading channel. Remove the effects of multipath fading using a simple,
%least squares solution, and demodulate the OFDM waveform and QPSK data.
%Generate error statistics by comparing the original data with the
%demodulated data.
for k = 1:nframes
   %Find row indices for kth OFDM frame
   indData = (k-1)*ofdmModDim.DataInputSize(1)+1:k*numData;
   
   %Generate random OFDM pilot symbols
   pilotData = complex(rand(ofdmModDim.PilotInputSize),...
       rand(ofdmModDim.PilotInputSize));
   
   %Modulate QPSK symbols using OFDM
   dataOFDM = ofdmMod(modData(indData,:,:),pilotData);
   
   %Create flat, i.i.d., Rayleigh fading channel
   %chGain = complex(randn(2,2),randn(2,2))/sqrt(2); %Random 2x2 channel
   [y11, g11] = chanComp1(dataOFDM(:,1));
   [y12, g12] = chanComp1(dataOFDM(:,2));

   [y21, g21] = chanComp2(dataOFDM(:,1));
   [y22, g22] = chanComp2(dataOFDM(:,2));
   
   [y1] = [y11, y12];
   [y2] = [y21, y22];
   
   [g1] = [g11, g12];
   [g2] = [g21, g22];
   
   y_temp = sqrt(gGauss1) * y1 ... 
       + sqrt(gGauss2) * y2;
   %tapped delay
   g_temp = sqrt(gGauss1) * g1 ...
       + sqrt(gGauss2) * g2;
   

   %%%
   %Pass OFDM signal through Rayleigh and AWGN channels
   receivedSignal = awgn(g_temp, 30);
   %%%%
   
   %Apply least squares solution to remove effects of fading channel
   rxSigMF = g_temp .* pinv(receivedSignal.');
   
   %Demodulate OFDM data
   receivedOFDMData = ofdmDemod(rxSigMF).';
   
   %Demodulate QPSK data
   receivedData = qpskDemod(receivedOFDMData(:));
   
   %Compute error statistics
   dataTmp = data(indData,:,:);
   errors = errorRate(dataTmp(:), receivedData);
end
fprintf('\nSymbol error rate = %d from %d errors in %d symbols\n',errors)




