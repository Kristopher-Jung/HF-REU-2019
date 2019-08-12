function [e, equalizer] = equalizer_picker(rx, tx, M, data)
%% Initialize Look-up table
table = zeros(3,1);
%% Run Cognitive Engine per each of equalizers.
fprintf('training each of the equalizers.........\n')
tic % initialize timer
% LS-ZF
H_est=pinv(tx)*rx; % Lease Square
y=rx/H_est; % Zero Forcing Equalizer
d = pskdemod(y, M, pi/M); % Demodulation
[~,e1] = biterr(d, data); % Calculate BER
% LS-ZF-DFE-LMS
[~,e2] = dfe_lms_cognitive_engine(tx,y,data,M);
% LS-ZF-DFE-RLS
[~,e3] = dfe_rls_cognitive_engine(tx,y,data,M);
%% Save results to the table.
table(1,1) = e1;
table(2,1) = e2;
table(3,1) = e3;
toc
fprintf('Generated Table from trainer:\n');
disp(table);
%% Parse table for each of the equalizer and pick the best one.
[e,idx] = min(table);
fprintf('equalizer that produced minimum error out of traings: %d.\n',idx);
equalizer = idx;
end