function eqSym= MLSE_Preamble_fun(mod_order, equal_traceback_depth, num_samp, msgLength, preamble_postamble_ratio, snr, chnl_coef)
%Maximum likely sequence estimation is the most accurate given any
%circumstance, but is also extremely computationally complex. However given
%the complexity of MIMO HF being passed through the Watterson Model, this
%might be the best fit. % Recover a message that includes a preamble, equalize the signal, 
% and check the symbol error rate.

% Specify the modulation order, equalizer traceback depth, number of samples per symbol, preamble, and message length.
M = mod_order; 
tblen = equal_traceback_depth;
nsamp = num_samp;
%preamble = [3;1];
preamble=preamble_postamble_ratio;
msgLen = msgLength;

% Generate the reference constellation.
const = pskmod(0:3,4);

% Generate a message with random data and prepend the preamble to the message. Modulate the random data.
msgData = randi([0 M-1],msgLen,1);
msgData = [preamble; msgData];
msgSym = pskmod(msgData,M);

% Filter the data through a distortion channel and add Gaussian noise to the signal.
%chcoeffs = [0.623; 0.489+0.234i; 0.398i; 0.21];
chcoeffs=chnl_coef;
chanest = chcoeffs;
msgFilt = filter(chcoeffs,1,msgSym);
msgRx = awgn(msgFilt,snr,'measured');

% Equalize the received signal. To configure the equalizer, provide the channel estimate, reference constellation,
% equalizer traceback depth, operating mode, number of samples per symbol, and preamble. 
% The same preamble symbols appear at the beginning of the message vector and in the syntax for mlseeq. 
% Because the system uses no postamble, an empty vector iis specified as the last input argument in this mlseeq syntax.

% Check the symbol error rate of the equalized signal. Run-to-run esults vary due to use of random numbers.
eqSym = mlseeq(msgRx,chanest,const,tblen,'rst',nsamp,preamble,[]);
[nsymerrs,ser] = symerr(msgSym,eqSym)
end