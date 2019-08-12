clear;
clc;
M = 4;
snr = 30;
temp = 1;
for i = 0.00001:0.0001:0.001
    %Initialize Watterson Channel.
    wattersonChan = stdchan('iturHFMQ',20e6,1);
    mimoChan = comm.MIMOChannel('SampleRate',20e6,"FadingDistribution",'Rayleigh',...
        "AveragePathGains",wattersonChan.AveragePathGains,...
        "PathDelays",wattersonChan.PathDelays,"NormalizePathGains",wattersonChan.NormalizePathGains,...
        "MaximumDopplerShift",wattersonChan.MaximumDopplerShift,"DopplerSpectrum",wattersonChan.DopplerSpectrum,...
        "TransmitCorrelationMatrix", eye(2), "ReceiveCorrelationMatrix", eye(2));
    
    %Initialize AWGN Channel.
    awgn = comm.AWGNChannel('EbNo',30,'BitsPerSymbol',2, 'SignalPower', 1);
    
    % Create an error rate counter
    errorRate = comm.ErrorRate;
    
    % Apply OFDM modulation to the random symbols
    ofdmMod = comm.OFDMModulator('FFTLength',256,'PilotInputPort',true,...
        'InsertDCNull',true,...
        'NumTransmitAntennas',2);
    
    ofdmDemod = comm.OFDMDemodulator(ofdmMod);
    ofdmDemod.NumReceiveAntennas = 2;
    ofdmModDim = info(ofdmMod);
    numData = ofdmModDim.DataInputSize(1);   % Number of data subcarriers
    numSym = ofdmModDim.DataInputSize(2);    % Number of OFDM symbols
    numTxAnt = ofdmModDim.DataInputSize(3);  % Number of transmit antennas
    nframes = 100;
    data = randi([0 M-1],nframes*numData,numSym,numTxAnt);
    modData = pskmod(data(:), M);
    modData = reshape(modData,nframes*numData,numSym,numTxAnt);
    evm = comm.EVM('MaximumEVMOutputPort',true,...
        'XPercentileEVMOutputPort',true, 'XPercentileValue',90,...
        'SymbolCountOutputPort',true);
    eqlms = comm.LinearEqualizer(...
        'Algorithm','LMS','NumTaps',5,'StepSize',i,...
        'ReferenceTap', 1);
    P1 = 0;
    P2 = 0;
    
    for k = 1:nframes
        % Find row indices for kth OFDM frame
        indData = (k-1)*ofdmModDim.DataInputSize(1)+1:k*numData;
        
        % Generate random OFDM pilot symbols
        pilotData = complex(rand(ofdmModDim.PilotInputSize), ...
            rand(ofdmModDim.PilotInputSize));
        
        % Modulate QPSK symbols using OFDM
        initial_data = modData(indData,:,:);
        Tx = ofdmMod(initial_data,pilotData);
        
        % Applying MIMO Channel Fading in Watterson Setup
        Rx = mimoChan(Tx);
        
        % Applying AWGN Channel Fading
        Rx = awgn(Rx);
%         Rx1 = Rx(:,1);
%         Rx2 = Rx(:,2);
%         Tx1 = Tx(:,1);
%         Tx2 = Tx(:,2);
%         tx_est1 = eqlms(Rx1, Tx1);
%         tx_est2 = eqlms(Rx2, Tx2);
%         tx_est = [tx_est1, tx_est2];
%         H_est = Tx1*pinv(Rx1);
        [H_est, tx_est] = CMA(Rx, Tx, 5, 1);
        
        % LS based channel estimation
        %H_est=pinv(Tx)*Rx;
        
        % Zero Forcing based equalizer
        %tx_est=Rx/H_est;
        
        % Demodulate OFDM data
        receivedOFDMData = ofdmDemod(tx_est);
        
        % Calculate EVM
        [rmsEVM,maxEVM,pctEVM,numSym] = evm(initial_data,receivedOFDMData);
        EVM1(temp) = rmsEVM(:,:,1);
        EVM2(temp) = rmsEVM(:,:,2);
        
        % Demodulate QPSK data
        receivedData1 = pskdemod(receivedOFDMData(:,1), M);
        receivedData2 = pskdemod(receivedOFDMData(:,2), M);
        
        % Compute error statistics
        dataTmp = data(indData,:,:);
        errors1 = errorRate(dataTmp(:,:,1),receivedData1);
        errors2 = errorRate(dataTmp(:,:,2),receivedData2);
        y1(temp) = errors1(1);
        y2(temp) = errors2(1);
        % Calculating Power of the received signals.
        P1 = P1 + mean(20*log10(abs(Rx(:,1))));
        P2 = P2 + mean(20*log10(abs(Rx(:,2))));
        
        % The capacity of MIMO model
        Nr = 2;
        Nt = 2;
        N = min(Nr,Nt);
        [S V D] = svd(H_est*H_est');
        C_MIMO = 0;
        
        % When CSI is not available at the transmitter side
        for k=1:N
            lamda(k) = V(k,k);
            C_MIMO = C_MIMO + log2(1+i*lamda(k)/Nt);
        end
        C(snr) = C_MIMO;
        
    end
    %P(i) = (P1 + P2)/nframes;
    temp = temp + 1;
    % Print error message
    fprintf('\nSymbol error rate = %d from %d errors in %d symbols\n',errors1)
    fprintf('\nSymbol error rate = %d from %d errors in %d symbols\n',errors2)
    %     %fprintf('\nSymbol error rate = %d from %d errors in %d symbols\n',errors3)
    
    
end
k = 0.00001:0.0001:0.001
x = 1:10;
figure
subplot(4,1,1);
plot(k, y1, '-', 'LineWidth' , 1.5);
hold on;
plot(k, y2, ':', 'LineWidth' , 1.5);
legend('SER-1','SER-2');
xlabel("SNR(DB)");
ylabel("BER");
hold off;
% subplot(4,1,2);
% plot(x, C, '-');
% legend('Capacity');
% xlabel('SNR(DB)');
% ylabel('Capacity');
% subplot(4,1,3);
% plot(x,P, '-', 'LineWidth', 1.5);
% xlabel("SNR(DB)");
% ylabel("Average path Power Gain");
% hold off;
% subplot(4,1,4);
% plot(x, EVM1, '-', 'LineWidth', 1.5);
% hold on;
% plot(x, EVM2, ':', 'LineWidth', 1.5);
% legend('EVM1', 'EVM2');
% xlabel("SNR(DB)");
% ylabel("Root Mean Square EVM");
% hold off;

