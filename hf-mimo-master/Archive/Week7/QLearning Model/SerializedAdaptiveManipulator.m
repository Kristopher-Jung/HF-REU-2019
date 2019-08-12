function SerializedAdaptiveManipulator(qIterations,metaIterations, threshold)
%This function controls the overall process of the model, it runs each
%value in serial rather than paralell through it and adaptively
%manipulates the parameters and equalizers according to the changes in
%the BER. This allows for increase throughput while maintaining the
%full set of the action-space in q-learning.
    c=0;
    while 1~=0
        %~~~~~~~~~~~~~~~~~~~~Setup Initial Inputs~~~~~~~~~~~~~~~~
        
        %Set q-learning parameters
        discount_rate=.5;
        learning_rate=.5;
        explore_probability=.9;
        
        %Adjust Parameter Defaults
        M=4;
        
        %Generate Data
        numSymbols = 1e3; % number of symbols transmitted in total.
        data = randi([0 M-1],numSymbols,2); % Initialize random for training.
        
        
        switch M 
            % Picking low Sampling Rates standards
            % for the current modulation scheme in 6kHz bandwidth.
            case 2
                sr = 3.2e3;
            case 4
                sr = 6.4e3;
            case 8
                sr = 9.6e3;
            case 16
                sr = 12.8e3;
            case 32
                sr = 16e3;
            case 64
                sr = 19.2e3;
        end
        
        chan = comm.MIMOChannel(...
            'SampleRate',sr,...
            'FadingDistribution','Rayleigh',...
            'AveragePathGains',[0 0],...
            'PathDelays',[0 0.5] * 1e-3,...
            'DopplerSpectrum',doppler('Gaussian', 0.1/2),...
            'TransmitCorrelationMatrix', eye(2), ...
            'ReceiveCorrelationMatrix', eye(2));
        
        snr=15;%fixed
        RT=1;%fixed
        num_fts=4;%1 ~ 15
        num_fbts=4;%1 ~ 15
        step_size=0.01;% 0.00001 ~ 0.001
        FF=0.3; % 0.3 ~ 0.9
        equalizer=1; % 1 ~ 3
        
        %Set parameter minimums
        min_num_fts = 1;
        min_num_fbts = 1;
        min_step_size = 1;
        min_num_FF = 1;
        
        %Set parameter maximums
        max_num_fts = 15;
        max_num_fbts = 15;
        max_step_size = 99;
        max_num_FF = 99;
    %~~~~~~~~~~~~~~~Equalizer Selection(CE2)~~~~~~~~~~~~~~~~~~~~~~~
        
        
        %Finds the optimal equalizer for the given setup
        [eq, baseLineError]=BruteForce({chan, M, snr, RT, FF}, data, [num_fts, num_fbts, step_size]);
       
        %Sets the optimization set depending upon equalizer selected
         switch(eq)
             case 1
                 mini=[min_num_fts, min_num_fbts, min_num_FF];
                 maxi=[max_num_fts, max_num_fbts, max_num_FF];
                 
                 p={chan, M, snr, step_size, RT eq};
             case 2
                 mini=[min_num_fts, min_num_fbts, min_step_size];
                 maxi=[max_num_fts, max_num_fbts, max_step_size];
                 
                 p={chan, M, snr, FF, RT, eq};
         end
        
         
    %~~~~~~~~~~~~~~~~~~~~~~~~QLEARNING(CE1)~~~~~~~~~~~~~~~~~~~~~~~~
    
         %How many times the model runs for assuming there are no changes to
         %the equalizer. The number of metaiterations is multiplied by the
         %number of times a new equalizer is selected. It is best not to set
         %metaiterations too high when the model is not running in a continuous
         %mode.
        for i=1:metaIterations
                
            %Begins q-learning
            q=QLearn(data, discount_rate, learning_rate, explore_probability, qIterations, p, mini, maxi);
            
            %Sets up the parameters for the BER calculation after parameters
            %have been optimized.
            switch (p{5})
                case 1
                    num_fts=q(1);
                    num_fbts=q(2);
                    FF=q(3)/10;
                    
                    chan=p{1};
                    M=p{2};
                    snr=p{3};
                    step_size=p{4};
                    RT=p{5};
                    equalizer=p{6};
                
                case 2
                    num_fts=q(1);
                    num_fbts=q(2);
                    step_size=q(3)/10;
                    
                    chan=p{1};
                    M=p{2};
                    snr=p{3};
                    FF=p{4}/10;
                    RT=p{5};
                    equalizer=p{6};
            end
            
            %Calculates current error given the optimal equalizer and parameter
            %sets
            metaiterationError=objectiveFunction(data, chan, M, snr, [RT num_fts num_fbts step_size FF equalizer]);
            
            %Displays basline error
            disp(baseLineError);
            
            %Displays current metaiteration's error
            disp(metaiterationError);
            
            %Displays the summative error which is compared to the penalization
            % factor to decide if a change of equalizer is required.
    %         disp(baseLineError/metaiterationError-penalization);
            if(baseLineError<metaiterationError)
                    break;
            end
        end
        c=c+1;
        if(c==threshold)
            break;
        end
    end
end


