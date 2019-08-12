function errorVec=SerializedAdaptiveManipulator(qIterations,metaIterations, threshold)
%This function controls the overall process of the model, it runs each
%value in serial rather than paralell through it and adaptively
%manipulates the parameters and equalizers according to the changes in
%the BER. This allows for increase throughput while maintaining the
%full set of the action-space in q-learning.
c=1;
max_snr=30;
snr_range=[1:1:max_snr];

errorVec=zeros([metaIterations+1 max_snr]);

while 1~=0
    %~~~~~~~~~~~~~~~~~~~~Setup Initial Inputs~~~~~~~~~~~~~~~~
    
    %Set q-learning parameters
    discount_rate=.5;
    learning_rate=.5;
    explore_probability=.9;
    
    %Adjust Parameter Defaults
    M=4;
    nTx=2;
    nRx=2;
    fd=1;
    sGauss1 = 0.2;
    fGauss1 = -0.5;
    Rs=9600;
    sGauss2 = 0.1;
    fGauss2 = 0.4;
    gGauss1 = 1.2;       % Power gain of first component
    gGauss2 = 0.25;      % Power gain of second component
    [chanComp3, chanComp4] = Watterson_channel(nTx, nRx, fd, sGauss1, sGauss2, fGauss1, fGauss2, Rs);
    %snr=15;%fixed
    %Generate Data
    numSymbols = 200; % number of symbols transmitted in total.
    data = randi([0 M-1], numSymbols, nTx); % generated n-dimension random data.
    tx = pskmod(data(:), M, pi/M); % Input Modulation.
    tx = reshape(tx, numSymbols, nTx); % Reshape to pass the signal into wattersonMIMO
    [rx,~] = Watterson_transmit(tx, snr_range(c),chanComp3,chanComp4,gGauss1,gGauss2);
    equalizer=1; % 1 ~ 3
    pilot_freq=2;
    wl=10; %10~floor(ttlSymbols*nTx/10)
    var=0.1; %10^(-max(snr_range)) ~  10^(min(snr_range))
    
    %Set parameter minimums
    min_num_wl = 10;
    min_num_var = 1;
    
    %Set parameter maximums
    max_num_wl = floor(numSymbols*nTx/10);
    max_num_var = 9;
    %~~~~~~~~~~~~~~~Equalizer Selection(CE2)~~~~~~~~~~~~~~~~~~~~~~~
    
    
    %Finds the optimal equalizer for the given setup
    [eq, baseLineError]=BruteForce({tx, rx, M, pilot_freq}, [wl, var]);
    
    %Sets the optimization set depending upon equalizer selected
    switch(eq)
        case 1
            mini=[min_num_wl];
            maxi=[max_num_wl];
            
            p={tx, rx, M, pilot_freq, var, eq};
        case 2
            mini=[min_num_wl];
            maxi=[max_num_wl];
            
            p={tx, rx, M, pilot_freq, var, eq};
        case 3
            mini=[min_num_wl, min_num_var];
            maxi=[max_num_wl, max_num_var];
            
            p={tx, rx, M, pilot_freq, 1, eq};
    end
    
    
    %~~~~~~~~~~~~~~~~~~~~~~~~QLEARNING(CE1)~~~~~~~~~~~~~~~~~~~~~~~~
    q=QLearn(discount_rate, learning_rate, explore_probability, qIterations, p, mini, maxi);
    errorVec(metaIterations+1,c)=baseLineError;
    disp(baseLineError);
    %How many times the model runs for assuming there are no changes to
    %the equalizer. The number of metaiterations is multiplied by the
    %number of times a new equalizer is selected. It is best not to set
    %metaiterations too high when the model is not running in a continuous
    %mode.
    metaiterationError=0;
    i=0;
%   while(baseLineError>metaiterationError) %Continuous Operation
    while(i~=metaIterations) %Discrete Operation
       i=i+1; 
       
        
        %Sets up the parameters for the BER calculation after parameters
        %have been optimized.
        switch (p{6})
            case 1
                wl=q(1);
                
                tx=p{1};
                rx=p{2};
                M=p{3};
                pilot_freq=p{4};
                var=p{5};
                equalizer=p{6};
                
                
            case 2
                wl=q(1);
                
                tx=p{1};
                rx=p{2};
                M=p{3};
                pilot_freq=p{4};
                var=p{5};
                equalizer=p{6};
                
            case 3
                wl=q(1);
                var=q(2)/10;
                
                tx=p{1};
                rx=p{2};
                M=p{3};
                pilot_freq=p{4};
                placeholder=p{5};
                equalizer=p{6};
                
        end
        
        
        data = randi([0 M-1], numSymbols, nTx); % generated n-dimension random data.
        tx = pskmod(data(:), M, pi/M); % Input Modulation.
        tx = reshape(tx, numSymbols, nTx); % Reshape to pass the signal into wattersonMIMO
        [rx,~] = Watterson_transmit(tx, snr_range(c),chanComp3,chanComp4,gGauss1,gGauss2);
        
        %Calculates current error given the optimal equalizer and parameter
        %sets
        metaiterationError=objective_fun_q(tx, rx, M, pilot_freq, [equalizer, wl, var]);
        
        %Displays basline error
        
        errorVec(i, c)=metaiterationError;
        %Displays current metaiteration's error
        
        %Displays the summative error which is compared to the penalization
        % factor to decide if a change of equalizer is required.
        %         disp(baseLineError/metaiterationError-penalization);
    end
    c=c+1
    if(c==threshold)
        break;
    end
end

end

