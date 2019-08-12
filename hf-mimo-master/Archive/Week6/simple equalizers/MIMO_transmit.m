% simulate the transmission of signal Tx through the Watterson channel in a MIMO system
% parameters:
%   - Tx = modulated transmitted signal
%   - SNR = signal-to-noise ratio (Eb/N0)
%   - Channel = 'Watterson' or 'Rayleigh' determines what channel to
%   transmit through
%   - nTx = number of transmit antennas
%   - nRx  = number of receive antennas
function Rx = MIMO_transmit(Tx, SNR, Channel, nTx, nRx)

% HEY DON'T EVER USE THIS FUNCTION
% it's super broken, use builtin awgn(signal, SNR, 'measured') instead
% create an AWGN model to add white noise to the signal
% noise = comm.AWGNChannel('NoiseMethod','Signal to noise ratio (SNR)','SNR',SNR,'SignalPower', 1);

%so we can comment out the first line below without having to change the
%final line as well
switch Channel
    case 'Watterson'
        
        %create a Watterson channel whose variables we can then repurpose into our MIMO model of the channel
        chanModel = stdchan('iturHFMQ',20e6,1);
        
        % create the actual channel we will pass the signal through
        wattersonMIMO = comm.MIMOChannel('SampleRate',12000,"FadingDistribution",'Rayleigh',...
            "AveragePathGains",chanModel.AveragePathGains,...
            "PathDelays",chanModel.PathDelays,"NormalizePathGains",chanModel.NormalizePathGains,...
            "MaximumDopplerShift",chanModel.MaximumDopplerShift,"DopplerSpectrum",chanModel.DopplerSpectrum,...
            "TransmitCorrelationMatrix", eye(2), "ReceiveCorrelationMatrix", eye(2));
        
        Rx = Tx;
            
        %run the signal through the Watterson MIMO channel
        Rx =  wattersonMIMO(Rx);
        
        %apply AWGN to the signal
        Rx = awgn(Rx,SNR,'measured'); %working buit-in AWGN method
    case 'Rayleigh'
        rayleighMIMO = comm.MIMOChannel('SampleRate',12000, ...
            'MaximumDopplerShift',0, 'SpatialCorrelationSpecification','None', ...
            'NumTransmitAntennas',nTx, 'NumReceiveAntennas',nRx);
        
        Rx = Tx;    
            
        Rx = rayleighMIMO(Rx);
        
        Rx = awgn(Rx,SNR,'measured'); %working buit-in AWGN method
    case 'AWGN'
        %apply AWGN to the signal
        Rx = awgn(Rx,SNR,'measured'); %working buit-in AWGN method
        
    case 'Manual Rayleigh'
        
        N0 = 1/10^(SNR / 10);
        
        h = 1/sqrt(2)*[randn(1,length(Tx)) + i*randn(1,length(Tx))]; 

        Rx1 = (times(h.',Tx(:,1))).' + sqrt(N0/2)*[randn(1,length(Tx))+i*randn(1,length(Tx))];    
        Rx2 = (times(h.',Tx(:,2))).' + sqrt(N0/2)*[randn(1,length(Tx))+i*randn(1,length(Tx))];
        Rx1 = Rx1.';
        Rx2 = Rx2.';
        Rx = cat(2,Rx1, Rx2);
end
end