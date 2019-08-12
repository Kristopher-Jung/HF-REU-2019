function [X_quan, sqnr] = adpt_delta_mod(X,K,delta_in)
% 		Adaptive Delta modulation of Sequence X, Given delta.
% 		X = Input Sequence.
% 		delta_in = Initial step size.
% 		Y_quan = The accumulation value.
% 		X_quan = Quantized version of X.
% 		epsi = Output of the quantizer before being scaled by the step size.
% 		QE_delta_mod = Quantization error vector.
% 		sqnr = output SQNR (in dB).
% 		delta = vector of step sizes.
% 		K = Constant larger than one.

l = size(X,2);
Y_quan = zeros(1,l);
X_quan = zeros(1,l);
epsi = zeros(1,l);
delta = zeros(1,l);
delta(1) = delta_in;
if X(1) >= 0
    epsi(1) = 1;
else
    epsi(1) = -1;
end
Y_quan(1) = epsi(1) * delta(1);
X_quan(1) = Y_quan(1);
for n = 2:l
    if X(n) >= X_quan(n-1)
        epsi(n) = 1;
    else
        epsi(n) = -1;
    end
    delta(n) = delta(n-1) * K ^ (epsi(n)*epsi(n-1));
    Y_quan(n) = epsi(n) * delta(n);
    X_quan(n) = X_quan(n-1) + Y_quan(n);
end
sqnr = 20*log10(norm(X)/norm(X-X_quan));