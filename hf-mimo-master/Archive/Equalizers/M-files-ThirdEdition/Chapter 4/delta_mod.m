function [X_quan, sqnr]=delta_mod(X,delta)
% 		Delta modulation of Sequence X, Given delta.
% 		[X_QUAN, SQNR]=DELTA_MOD(X,DELTA)
% 		X = Input Sequence
% 		delta = Step size
% 		Y_quan = The accumulation value
% 		X_quan = Quantized version of X
% 		epsi = Output of the quantizer before being scaled by the step size
% 		sqnr = output SQNR (in dB)
% 		QE_delta_mod = Quantization error vector

l = size(X,2);
Y_quan = zeros(1,l);
X_quan = zeros(1,l);

if X(1) >= 0
    epsi = 1;
else
    epsi = -1;
end
Y_quan(1) = epsi * delta;
X_quan(1) = Y_quan(1);

for n = 2:l
    if X(n) >= X_quan(n-1)
        epsi = 1;
    else
        epsi = -1;
    end
    Y_quan(n) = epsi * delta;
    X_quan(n) = X_quan(n-1) + Y_quan(n);
end

sqnr = 20*log10(norm(X)/norm(X-X_quan));
QE_delta_mod = X-X_quan;