function eqSym= MLSE_Reset_fun(mod_order, equal_traceback_depth, num_samp, msgLength, preamble_postamble_ratio, snr, chnl_est)
%Maximum likely sequence estimation is the most accurate given any
%circumstance, but is also extremely computationally complex. However given
%the complexity of MIMO HF being passed through the Watterson Model, this
%might be the best fit. This is for reset operation of MLSE, which is what
%we are currently doing.

%Specify the modulation order, equalizer traceback depth, number of samples per symbol, and message length.
M = mod_order;
tblen =  equal_traceback_depth;
nsamp = num_samp;
msgLen = msgLength;

% Generate the reference constellation.
const = pammod([0:M-1],M);

% Generate a message with random data. Modulate and upsample the signal.
msgData = randi([0 M-1],msgLen,1);
msgSym = pammod(msgData,M);
msgSymUp = upsample(msgSym,nsamp);

% Filter the data through a distortion channel and add Gaussian noise to the signal.
%chanest = [0.986; 0.845; 0.237; 0.12345+0.31i];
chanest = chnl_est
msgFilt = filter(chanest,1,msgSymUp);
msgRx = awgn(msgFilt,snr,'measured');

% Equalize and then demodulate the signal to recover the message. To initialize the equalizer,
% provide the channel estimate, reference constellation, equalizer traceback depth, number of samples per symbol,
% and set the operating mode to reset. Check the message bit error rate. Your results might vary because this example uses random numbers.
eqSym = mlseeq(msgRx,chanest,const,tblen,'rst',nsamp);
eqMsg = pamdemod(eqSym,M);

%Bit Error Rate(BER)=Number of incorrect symbols/total symbols
[nerrs ber] = biterr(msgData, eqMsg)
end