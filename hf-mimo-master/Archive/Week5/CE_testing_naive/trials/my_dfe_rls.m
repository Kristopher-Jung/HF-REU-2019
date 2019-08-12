function e = my_dfe_rls(nFwdTaps,nFdbkTaps,rx,tx,data,M)
eq = comm.DecisionFeedbackEqualizer('Algorithm','RLS', ...
        'NumForwardTaps',nFwdTaps,'NumFeedbackTaps',nFdbkTaps, ...
        'ReferenceTap',1);
[y,~,~] = eq(rx, tx);
d = pskdemod(y, M, pi/M);
NrNaN = sum(isnan(d(:)));
if NrNaN ~= 0
    e = 1;
else
    [~,e] = biterr(d, data(:));
end
end