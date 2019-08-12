function [lowest, lowErr] = BruteForce(params, ret)
%This function tries all available equalizers and finds out which has the
%lowest error

    %Initialization
    e=zeros([1,3]);
    lowest=1;
    
    %Sets up the optimization parameters
    wl=ret(1);
    variance=ret(2);
    
    %Sets up the constant parameters
    tx=params{1};
    rx=params{2};
    M=params{3};
    pilot_freq=params{4};
    
    %Runs all equalizers
    for equalizer = 1:3
        e(equalizer)=objective_fun_q(tx, rx, M, pilot_freq, [equalizer, wl, variance]);
        if(e(equalizer)<e(lowest))
            lowest=equalizer;
        end
    end
    %Returns equalizer with lowest error and the error correspondent to it.
    lowErr=e(lowest);
end
