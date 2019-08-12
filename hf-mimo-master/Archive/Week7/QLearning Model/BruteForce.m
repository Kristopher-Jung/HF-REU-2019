function [lowest, lowErr] = BruteForce(params, data, ret)
%This function tries all available equalizers and finds out which has the
%lowest error

    %Initialization
    e=zeros([1,2]);
    lowest=1;
    
    %Sets up the optimization parameters
    num_fts=ret(1);
    num_fbts=ret(2);
    step_size=ret(3);
    
    %Sets up the constant parameters
    chan=params{1};
    M=params{2};
    snr=params{3};
    RT=params{4};
    FF=params{5};
    
    %Runs all equalizers
    for equalizer = 1:2
        e(equalizer)=objectiveFunction(data, chan, M, snr, [RT num_fts num_fbts step_size FF equalizer]);
        if(e(equalizer)<e(lowest))
            lowest=equalizer;
        end
    end
    %Returns equalizer with lowest error and the error correspondent to it.
    lowErr=e(lowest);
end

