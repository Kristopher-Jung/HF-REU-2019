function [eqSym,eq_metric,eq_states,eq_inputs] = MLSE_Continous_fun(mod_order, equal_traceback_depth, num_samp, msgLength, numPakts, snr, chnl_est)
%Maximum likely sequence estimation is the most accurate given any
%circumstance, but is also extremely computationally complex. However given
%the complexity of MIMO HF being passed through the Watterson Model, this
%might be the best fit. This is for continous operation of MLSE, which is not what
%we are currently doing, but will likely be doing later.

% Specify the modulation order, equalizer traceback depth, number of samples per symbol, message length, and number of packets to process.
M = mod_order;
tblen =  equal_traceback_depth;
nsamp = num_samp;
msgLen = msgLength;
numPkts = numPakts;

% Generate the reference constellation.
const = pskmod(0:M-1,M);

% Set the initial input parameters for the metric, states, and inputs of the equalizer to empty vectors.
% These initial assignments represent the parameters for the first packet transmitted.
eq_metric = [];
eq_states = [];
eq_inputs = [];

% Assign variables for symbol error statistics.
ttlSymbErrs = 0;
aggrPktSER = 0;

% Send and receive multiple message packets in a simulation loop. 
% Between the packet transmission and reception filter each packet through a distortion channel and add Gaussian noise.
for jj = 1:numPkts
    %     Generate a message with random data. Modulate the signal.
    
    msgData = randi([0 M-1],msgLen,1);
    msgMod = pskmod(msgData,M);
    %     Filter the data through a distortion channel and add Gaussian noise to the signal.
    
    %chanest = [.986; .845; .237; .12345+.31i];
    chanest=chnl_est
    msgFilt = filter(chanest,1,msgMod);
    msgRx = awgn(msgFilt,snr,'measured');
    
    %     Equalize the received symbols. To configure thzee equalizer, provide the channel estimate, 
    % reference constellation, equalir traceback depth, operating mode, number of samples per symbol, and
    % the equalizer initialization information. Continuous operating mode is specified for the equalizer.
    % In continuous operating mode, the equalizer initialization information (metric, states, and inputs) 
    % are returned and used as inputs in the next iteration of the for loop.
    [eqSym,eq_metric,eq_states,eq_inputs] = ...
        mlseeq(msgRx,chanest,const,tblen,'cont',nsamp, ...
        eq_metric,eq_states,eq_inputs);
    

    %     Save the symbol error statistics. Update the symbol error statistics with the aggregate results. 
    % Display the total number of errors. Your results might vary because this example uses random numbers.
    [nsymerrs,ser] = symerr(msgMod(1:end-tblen),eqSym(tblen+1:end));
    ttlSymbErrs = ttlSymbErrs + nsymerrs;
    aggrPktSER = aggrPktSER + ser;
end
printTtlErr = 'A total of %d symbol errors over the %d packets received.\n';
fprintf(printTtlErr,ttlSymbErrs,numPkts);

% Display the aggregate symbol error rate.
printAggrSER = 'The aggregate symbol error rate was %6.5d.\n';
fprintf(printAggrSER,aggrPktSER/numPkts);
end