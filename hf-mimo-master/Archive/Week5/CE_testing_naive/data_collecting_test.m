clc;
clear;
for m = 1:6
    M = 2^m;
    metaTs = [];
    Ts = [];
    filename = 'cog_testing_data_v2.xlsx';
    for snr = 1:20
        [x,fval,population,scores] = cognitive_engine(M, snr);
        scoreDim = size(scores);
        metaT = array2table([snr,fval,x], 'VariableNames',...
            {'CurrSNR','BestErr','BestrefTap','BestnFwdTaps',...
            'BestnFdbkTaps','Beststepsz','Bestforgfec','Bestalg'});
        metaTs = [metaTs;metaT];
        dim = size(scores);
        snrs = repelem(snr,dim(1));
        T = array2table([snrs(:), scores], ...
            'VariableNames', {'SNR','refTap','nFwdTaps','nFdbkTaps','stepsz','forgfec','alg'});
        Ts = [Ts;T];
    end
    writetable(metaTs,filename,'Sheet',int2str(M)+"-PSK"+"-Bests");
    writetable(Ts,filename,'Sheet',int2str(M)+"-PSK"+"-Scores");
end