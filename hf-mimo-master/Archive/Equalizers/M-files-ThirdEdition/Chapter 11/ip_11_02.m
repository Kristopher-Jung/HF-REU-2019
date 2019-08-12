% MATLAB script for Illustrative Problem 11.2

Nt = 2;                                         % No. of transmit antennas
Nr = 2;                                         % No. of receive antennas
S = [1 1 -1 -1; 1 -1 1 -1];                     % Reference codebook
H = (randn(Nr,Nt) + 1i*randn(Nr,Nt))/sqrt(2);   % Channel coefficients
s = 2*randi([0 1],Nt,1) - 1;                    % Binary transmitted symbols
No = 0.1;                                       % Noise Noiance
noise = sqrt(No/2)*(randn(Nr,1) + 1i*randn(Nr,1)); % AWGN noise
y = H*s + noise;                                % Inputs to the detectors
disp(['The transmitted symbols are:                     ',num2str(s')])

% Maximum Likelihood Detector:
mu = zeros(1,4);
for i = 1:4
    mu(i) = sum(abs(y - H*S(:,i)).^2);          % Euclidean distance metric
end
[Min idx] = min(mu);
s_h = S(:,idx);
disp(['The detected symbols using the ML method are:    ',num2str(s_h')])

% MMSE Detector:
w1 = (H*H' + No*eye(2))^(-1) * H(:,1);          % Optimum weight vector 1
w2 = (H*H' + No*eye(2))^(-1) * H(:,2);          % Optimum weight vector 2
W = [w1 w2];
s_h = W'*y;
for i = 1:Nt
    if s_h(i) >= 0
        s_h(i) = 1;
    else
        s_h(i) = -1;
    end
end
disp(['The detected symbols using the MMSE method are:  ',num2str(s_h')])

% Inverse Channel Detector:
s_h = H\y;
for i = 1:Nt
    if s_h(i) >= 0
        s_h(i) = 1;
    else
        s_h(i) = -1;
    end
end
disp(['The detected symbols using the ICD method are:   ',num2str(s_h')])