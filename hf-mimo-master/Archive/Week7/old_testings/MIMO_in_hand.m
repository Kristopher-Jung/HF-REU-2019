clc;
clear;
mimo.M = 4;
mimo.nTx = 2;
mimo.nRx = 2;
mimo.nTsyms = 2e3;
mimo.sRate = 9.6e3;

for snr = 1 : 15
    for mc = 1 : 10
        mimo.d = randi([0 mimo.M-1], mimo.nTsyms, mimo.nTx);
        mimo.dPsk = nan(mimo.nTsyms, mimo.nTx);
        for nt = 1 : mimo.nTx
            mimo.dPsk(:, nt) = pskmod(mimo.d(:, nt), mimo.M, pi/mimo.M);
        end
        sGauss1 = 0.2;
        fGauss1 = -0.5;
        fd = 1;
        dopplerComp1 = doppler('BiGaussian', ...
            'NormalizedStandardDeviations', [sGauss1/fd 1/sqrt(2)], ...
            'NormalizedCenterFrequencies',  [fGauss1/fd 0], ...
            'PowerGains',                   [0.5        0]);
        chanComp1 = comm.RayleighChannel( ...
            'SampleRate',          mimo.sRate, ...
            'MaximumDopplerShift', fd, ...
            'DopplerSpectrum',     dopplerComp1, ...
            'PathGainsOutputPort', true);
        sGauss2 = 0.1;
        fGauss2 = 0.4;
        dopplerComp2 = doppler('BiGaussian', ...
            'NormalizedStandardDeviations', [sGauss2/fd 1/sqrt(2)], ...
            'NormalizedCenterFrequencies',  [fGauss2/fd 0], ...
            'PowerGains',                   [0.5        0]);
        chanComp2 = comm.RayleighChannel( ...
            'SampleRate',          mimo.sRate, ...
            'MaximumDopplerShift', fd, ...
            'DopplerSpectrum',     dopplerComp2, ...
            'PathGainsOutputPort', true);
        gGauss1 = 1.2;       % Power gain of first component
        gGauss2 = 0.25;      % Power gain of second component
        mimo.dChan = zeros(mimo.nTsyms, mimo.nRx);
        mimo.dChan1 = zeros(mimo.nTsyms, mimo.nRx);
        mimo.dChan2 = zeros(mimo.nTsyms, mimo.nRx);
        for nt = 1 : mimo.nTx
            for nr = 1 : mimo.nRx
                [y1, g1] = chanComp1(mimo.dPsk(:, nt));
                [y2, g2] = chanComp2(mimo.dPsk(:, nt));
                mimo.dChan(:, nr) = mimo.dChan(:, nr) + ...
                    awgn(sqrt(gGauss1) * y1 + sqrt(gGauss2) * y2, snr, 'measured');
            end
        end
        
        % Equalization
        mimo.Hest = pinv(mimo.dPsk)*mimo.dChan;
        mimo.Xest = mimo.dChan/mimo.Hest;
        zf_received = pskdemod(mimo.Xest, mimo.M, pi/mimo.M);
        [~, e1(mc)] = biterr(zf_received(:), mimo.d(:));
        eq = comm.DecisionFeedbackEqualizer('Algorithm','LMS', ...
            'NumForwardTaps',4,'NumFeedbackTaps',3,'ReferenceTap',1,...
            'Constellation',pskmod([0 mimo.M-1],mimo.M,pi/mimo.M), 'StepSize', 0.001);
        mimo.Xeqd = eq(mimo.Xest(:), mimo.dPsk(:));
        zfdfe_received = pskdemod(mimo.Xeqd, mimo.M, pi/mimo.M);
        [~, e2(mc)] = biterr(zfdfe_received(:), mimo.d(:));
    end
    err1(snr) = mean(e1);
    err2(snr) = mean(e2);
end
figure;
hold on;
plot(err1);
plot(err2);
hold off;
legend('zf','zfdfe');
grid on;

