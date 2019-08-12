function e = MIMO_PARAMATIZED_FUNC(...
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

% Apply OFDM modulation to the random symbols
ofdmMod = comm.OFDMModulator(...
    'FFTLength',2^FFT_len_power,...
    'PilotInputPort',true,...
    'NumTransmitAntennas',nTransmit, 'NumSymbols',100);

% Modulate Data
modData = pskmod(data(:), PSK_order);


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
    
    switch Algorithm
        case 'LMS'
            eq = comm.DecisionFeedbackEqualizer('Algorithm','LMS', ...
                'NumForwardTaps',num_fts,'NumFeedbackTaps',num_fbts,'StepSize',step_size, 'ReferenceTap', RT);
            [y,err,wts] = eq(Rx(:),Tx(1:1000,:));
            e = mean((abs(err)));
        case 'RLS'
            eq = comm.DecisionFeedbackEqualizer('Algorithm','RLS', ...
                'NumForwardTaps',num_fts,'NumFeedbackTaps',num_fbts,...
                'ReferenceTap', RT, 'ForgettingFactor', FF);
            [y,err,wts] = eq(Rx(:),Tx(1:1000,:));
            e = mean((abs(err)));
        case 'CMA'
            eq = comm.DecisionFeedbackEqualizer('Algorithm','CMA', ...
                'NumForwardTaps',num_fts,'NumFeedbackTaps',num_fbts,'StepSize',step_size, 'ReferenceTap', RT);
            [y,err,wts] = eq(Rx(:),Tx(1:1000,:));
            e = mean((abs(err)));
        case 'LS_ZF'
            H_est=pinv(Tx)*Rx;
            y=Rx/H_est;
            errorRate = comm.ErrorRate;
            sdf = pskdemod(y, PSK_order);
            errors = errorRate(initial_data, pskdemod(y, PSK_order));
            e = errors(1);
    end
end




