% simulate the transmission of signal Tx through the Watterson channel in a MIMO system
% parameters:
%   - Tx = modulated transmitted signal
%   - SNR = signal-to-noise ratio (Eb/N0)
%   - M = modulation degree
function Rx = MIMO_Watterson_transmit(Tx, SNR)

% HEY DON'T EVER USE THIS FUNCTION
% it's super broken, use builtin awgn(signal, SNR, 'measured') instead
% create an AWGN model to add white noise to the signal
% noise = comm.AWGNChannel('NoiseMethod','Signal to noise ratio (SNR)','SNR',SNR,'SignalPower', 1);

%create a Watterson channel whose variables we can then repurpose into our MIMO model of the channel
chanModel = stdchan('iturHFMQ',20e6,1);

% create the actual channel we will pass the signal through
wattersonMIMO = comm.MIMOChannel('SampleRate',20e6,"FadingDistribution",'Rayleigh',...
    "AveragePathGains",chanModel.AveragePathGains,...
    "PathDelays",chanModel.PathDelays,"NormalizePathGains",chanModel.NormalizePathGains,...
    "MaximumDopplerShift",chanModel.MaximumDopplerShift,"DopplerSpectrum",chanModel.DopplerSpectrum,...
    "TransmitCorrelationMatrix", eye(2), "ReceiveCorrelationMatrix", eye(2));

%so we can comment out the first line below without having to change the
%final line as well
Rx = Tx; 

%run the signal through the Watterson MIMO channel
Rx =  wattersonMIMO(Rx); 

%apply AWGN to the signal
Rx = awgn(Rx,SNR,'measured'); %working buit-in AWGN method
end