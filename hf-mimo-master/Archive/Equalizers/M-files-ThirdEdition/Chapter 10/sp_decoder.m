function [c check] = sp_decoder(H,y,max_it,E,EbN0_dB)
%SP_DECODER is the Sum-Product decoder for a linear block code code with BPSK modulation
%   [c check] = sp_decoder(H,y,max_it,N0) 
%   y           channel output 
%   H           parity-check matrix of the code
%   max_it      maximum number of iterations 
%   E           symbol energy
%   EbN0_dB     SNR/bit (in dB)
%   c           decoder output
%   check       is 0 if c is a codeword and is 1 otherwise

n = size(H,2);                  % Length of the code
f = size(H,1);                  % Number of parity checks
R = (n-f)/n;                    % Rate
Eb = E/R;                       % Energy/bit
N0 = Eb*10^(-EbN0_dB/10);       % one-sided noise PSD
L_i = 4*sqrt(E)*y/N0;
[j i] = find(H);
nz = length(find(H));
L_j2i = zeros(f,n);
L_i2j = repmat(L_i,f,1) .* H;
L_i2j_vec = L_i + sum(L_j2i,1);
% Decision making:
L_i_total = L_i2j_vec;
for l = 1:n
    if L_i_total(l) <= 0
        c_h(l) = 1;
    else
        c_h(l) = 0;
    end
end
s = mod(c_h*H',2);
if nnz(s) == 0
    c = c_h;
else
    it = 1;
    while ((it <= max_it) && (nnz(s)~=0))
        % Variable node updates:
        for idx = 1:nz
            L_i2j(j(idx),i(idx)) = L_i2j_vec(i(idx)) - L_j2i(j(idx),i(idx));
        end
        % Check node updates:
        for q = 1:f
            F = find(H(q,:));
            L_j2i_vec(q) = prod(tanh(0.5*L_i2j(q,F(:))),2);
        end
        for idx = 1:nz
            L_j2i(j(idx),i(idx)) = 2*atanh(L_j2i_vec(j(idx)) /...
                tanh(0.5*L_i2j(j(idx),i(idx))));
        end
        L_i2j_vec = L_i + sum(L_j2i,1);
        % Decision making:
        L_i_total = L_i2j_vec;
        for l = 1:n
            if L_i_total(l) <= 0
                c_h(l) = 1;
            else
                c_h(l) = 0;
            end
        end
        s = mod(c_h*H',2);
        it = it + 1;
    end
end
c = c_h;
check = nnz(s);
if (check > 0)
    check = 1;
end