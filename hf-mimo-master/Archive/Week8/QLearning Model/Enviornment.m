function [next_state,r] = Enviornment(x,u, p, data, ret)    
%The enviroment for the q-learning to process the data through and
%calculate reward.

    %Maintains state
    next_state=x;
    
    %Switch parameters and optimizers depending on equalizer
    switch (p{6})
    case 1
        num_fts=ret(u,1);
        num_fbts=ret(u,2);
        FF=(ret(u,3))/10;
        
        chan=p{1};
        M=p{2};
        snr=p{3};
        step_size=p{4};
        RT=p{5};
        equalizer=p{6};
    
    case 2
        num_fts=ret(u,1);
        num_fbts=ret(u,2);
        step_size=ret(u,3)/10;
        
        chan=p{1};
        M=p{2};
        snr=p{3};
        FF=p{4}/10;
        RT=p{5};
        equalizer=p{6};
    end
    
    %Caclulate the error
    e=objectiveFunction(data, chan, M, snr, [RT num_fts num_fbts step_size FF equalizer]);
    
    %Return reciprocal of error as reward
    r=1/e;
 
end