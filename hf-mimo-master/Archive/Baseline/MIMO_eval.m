% extract relevant information out of received and transmitted data. can be
% modified to return more useful pieces of information. 
function [e, BER] = MIMO_eval(received, transmitted)    

    %calculate BER
    errors = 0;
    
    for i = 1:length(received)
        for j = 1:length(received(1))
            if transmitted(i,j) ~= received(i,j)
                errors = errors + 1; 
            end
        end
    end
    
    e = errors; 
    BER = errors / numel(transmitted); 
end