% functionalized, still very broken DFE implementation
% 
% PARAMETERS
%   - u = received, raw transmission of dimensions syms x nRx
%   - pathgains = comm.MIMOChannel output variable associated with the transmission
%   - Tx_mod = modulated Tx symbols
%   - modulation = degree of modulation
%   - Nf = number feedforward taps
%   - Q = number feedback taps
%   - delta = time delay (integer)
%   - SNR = SNR
%   - mu = literally no idea. 0.01 seems good?
%   - training = number of data points to take as training data. If training = -1, it will default to the 
%       length of the entire transmitted sequence

% default call: paper_dfe_fun(u, pathgains, Tx_mod, modulation, 4, 3, 1, SNR, 0.01, -1); 
function [eq_Rx, BER] = paper_dfe_fun (u, pathgains, Tx_mod, modulation, Nf, Q, delta, SNR, mu, training)

        % M = number transmit antennas
        [~,M] = size(Tx_mod);
        
        % syms_per_Tx = number of symbols transmitted per antenna
        % N = number of receive antennas
        [syms_per_Tx, N] = size(u); 
        
        % select full training data if better isn't given
        if training == -1
            training = syms_per_Tx; 
        end

        % Nc = number of multipath in actual channel minus 1 (multipath = Nc + 1)
        [~,Nc,~,~] = size(pathgains);
        Nc = Nc - 1;
        
        sd2 = 1; % variance of transmit power. Not sure how to calculate this. 
        sv2 = sd2./10.^(SNR);% variance of noise power
        
        % conveniently padded transmitted data to use for error vector calculation
        Tx_mod_padded = [zeros(Q,M);Tx_mod];
        
        % pad out the receive vector with zeros so we don't go out of bounds with the frame
        u_padded = [u; zeros(Nf, N)];
        
        % C = modified channel matrix, as defined in https://link.springer.com/content/pdf/10.1023%2FA%3A1014993817231.pdf
        C = nan(syms_per_Tx, M * (Nf + Nc + 1), N * (Nf + 1));
        for timestep = 1:syms_per_Tx
            Ci = [];
            for j = 0:Nf
                Cj = zeros(M * j,N);
                for tap = 1:Nc + 1
                    c = squeeze(pathgains(timestep,tap,:,:));
                    Cj = [Cj; c];
                end
                Cj = [Cj; zeros(M * (Nf - j),N)];
                if isempty(Ci)
                    Ci = Cj;
                else
                    Ci = [Ci Cj];
                end
            end
            C(timestep,:,:) = Ci;
        end
        
        %initial values for matricies making up W. These are created separately and
        %then merged into an initial W0 which will then be adjusted independently.
        F = mu * (zeros(N * (Nf + 1),M) + 1i * zeros(N * (Nf + 1),M)); % Represents feedforward taps.
        B = mu * tril((ones(M) + 1i * ones(M)),-1);
        for i = 1:Q
            B = [B; mu * (ones(M) + 1i * ones(M))]; % Represents feedback taps. needs to be lower-triangular
        end
        
        W = [-1 * B; F]; %initialize a W matrix
        
        y = [zeros(Q + delta, M * (Q + 1) + N * (Nf + 1)); nan(syms_per_Tx, M * (Q + 1) + N * (Nf + 1))];
        
        d_h = [zeros(Q + delta, M); nan(size(Tx_mod))];
        
        % run the DFE for each received symbol
        for timestep = 1:syms_per_Tx
            
            if sum(sum(isnan(W))) > 0
                disp(['nan occurring in W at timestep ', num2str(timestep)]);
            end
            
            df = [];
            for i = 0:Q
                if timestep > training
                    df = [df d_h(timestep + Q - i,:)];
                else
                    % if it's training use the known correct values for this
                    df = [df Tx_mod_padded(timestep + Q - i,:)];
                end
            end
            uj = [];
            for i = 0:Nf
                uj = [uj u_padded(timestep + i,:)];
            end
            
            if sum(sum(isnan(df))) > 0
                disp(['nan occurring in df at timestep ', num2str(timestep)]);
            end
            
            y(timestep,:) = [df uj];
            
            d_h(Q + delta + timestep,:) = y(timestep,:) * W;
            
            % calculate new W value
            % define all the very terrible matrices used by the paper
            
            Ry = xcorr2(d_h(Q + timestep,:),uj.');
            
            M1 = [(sd2 * eye(M * (Q + 1), M)); Ry];
            
            M21 = squeeze(C(timestep,:,:))' * [zeros(M * delta, M * (Q + 1)); (sd2 * eye(M * (Q + 1))); zeros(M * (Nf + Nc - delta - Q), M * (Q+ 1))];
            
            M22 = sd2 * squeeze(C(timestep,:,:))' * eye(M * (Nf + Nc + 1)) * squeeze(C(timestep,:,:)) + sv2 * eye(N * (Nf + 1));
            
            M2 = [(sd2 * eye(M * (Q + 1))), M21';M21,M22];
            
            W = W + mu * (M1 - M2 * W);
        end
        
        eq_Rx = d_h(Q + delta + 1:end,:);
        
        Rx_syms = pskdemod(eq_Rx, modulation, pi/modulation); 
        
        Tx_syms = pskdemod(Tx_mod, modulation, pi/modulation);
        
        BER = (sum(sum(abs(Tx_syms - Rx_syms))) / numel(Tx_mod)); 
end