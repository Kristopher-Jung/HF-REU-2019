% GA CE testing Module.
clc;
clear;
refTap = []; % Number of reference taps
nFwdTaps = []; % Number of forward taps
nFdbkTaps = []; % Number of feedback taps
stepsz = []; % Step size
forgfec = []; % Forgetting Factor
alg = []; % Algorithm Choice
bestErr = [];
for m = 1:6
    M = 2^m;
    for snr = 1:20
        [x,fval,population,scores] = cognitive_engine(M, snr);
        refTap = [refTap;x(1)]; % Number of reference taps
        nFwdTaps = [nFwdTaps;x(2)]; % Number of forward taps
        nFdbkTaps = [nFdbkTaps;x(3)]; % Number of feedback taps
        stepsz = [stepsz;x(4)]; % Step size
        forgfec = [forgfec;x(5)]; % Forgetting Factor
        bestErr = [bestErr;fval]; % fvalue
        switch x(6)
            case 1
                alg = [alg;"LSZF"]; % Algorithm Choice
            case 2
                alg = [alg;"DFE RLS"]; % Algorithm Choice
            case 3
                alg = [alg;"DFE LMS"]; % Algorithm Choice
        end
    end
    snr = ["SNR-1";"SNR-2";"SNR-3";"SNR-4";"SNR-5";"SNR-6";"SNR-7";...
        "SNR-8";"SNR-9";"SNR-10";"SNR-11";"SNR-12";"SNR-13";"SNR-14";"SNR-15";...
        "SNR-16";"SNR-17";"SNR-18";"SNR-19";"SNR-20"];
    T = table(snr,bestErr,alg,refTap,nFwdTaps,nFdbkTaps,stepsz,forgfec);
    filename = 'cog_testing_data.xlsx';
    writetable(T,filename,'Sheet',int2str(M));
    refTap = []; % Number of reference taps
    nFwdTaps = []; % Number of forward taps
    nFdbkTaps = []; % Number of feedback taps
    stepsz = []; % Step size
    forgfec = []; % Forgetting Factor
    alg = []; % Algorithm Choice
    bestErr = [];
end