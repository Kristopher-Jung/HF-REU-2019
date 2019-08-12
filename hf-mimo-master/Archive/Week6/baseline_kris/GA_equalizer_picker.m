function [e, y, equalizer, t] = GA_equalizer_picker(rx, tx, M, data)
%% Initialize Look-up table
table = zeros(3,1);
%% Run Cognitive Engine per each of equalizers.
fprintf('training each of the equalizers.........\n')
tic % initialize timer
%% LS-ZF
H_est=pinv(tx)*rx; % Lease Square
y=rx/H_est; % Zero Forcing Equalizer
d = pskdemod(y, M, pi/M); % Demodulation
[~,e1] = biterr(d, data); % Calculate BER
y1 = y;
yy{1} = y1;
%% LS-ZF-DFE-LMS
[params,e2] = dfe_lms_cognitive_engine(rx,tx,data,M);
[~,y2] = my_dfe_lms(params(1),params(2),params(3),rx,tx,data,M);
yy{2} = y2;
%% LS-ZF-DFE-RLS
[params,e3] = dfe_rls_cognitive_engine(rx,tx,data,M);
[~,y3] = my_dfe_rls(params(1),params(2),rx,tx,data,M);
yy{3} = y3;
%% Save results to the table.
table(1,1) = e1;
table(2,1) = e2;
table(3,1) = e3;
t = toc;
fprintf('Generated Table from trainer:\n');
disp(table);
%% Parse table for each of the equalizer and pick the best one.
[e,idx] = min(table);
fprintf('equalizer that produced minimum error out of traings: %d.\n',idx);
fprintf('GA algorithm takes %d seconds\n',t);
equalizer = idx;
y = yy{idx};
end