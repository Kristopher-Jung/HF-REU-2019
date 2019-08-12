function [sqnr,X_quan,code]=d_pcm(X,level)
% D_PCM 		differential PCM encoding of a sequence
% 				X=input sequence.
% 				level=number of quantization levels (even).
% 				sqnr=output SQNR (in dB).
% 				X_quan=quantized output before encoding.
% 				code=the encoded output.
% 				QE_d_pcm=Quantization error.
% 				Y=input to the uniform quantizer
% 				Y_quan=output to the uniform quantizer
L=size(X,2);
code_dpcm=[];
n = 1;
Y(n) = X(n);
[sqnr,Y_quan,code] = u_pcm(Y(n),level);
Y_quan(n) = Y_quan;
X_quan(n) = Y_quan(n);
code_dpcm = [code_dpcm;code];
n = 2;
Y_quan_p(n-1) = Y_quan(n-1);
Y(n) = X(n) - Y_quan_p(n-1);
[sqnr,Y_quan,code] = u_pcm(Y(n),level);
Y_quan(n) = Y_quan;
X_quan(n) = Y_quan(n) + X_quan(n-1);
code_dpcm = [code_dpcm;code];
for n = 3:L
    Y_quan_p(n-1) = Y_quan(n-1) + Y_quan_p(n-2) ;
    Y(n) = X(n) - Y_quan_p(n-1);
    [sqnr,Y_quan,code] = u_pcm(Y(n),level);
    Y_quan(n) = Y_quan;
    X_quan(n) = Y_quan(n) + X_quan(n-1);
    code_dpcm = [code_dpcm;code];
end

QE_dpcm = X-X_quan;
sqnr=20*log10(norm(X)/norm(QE_dpcm));