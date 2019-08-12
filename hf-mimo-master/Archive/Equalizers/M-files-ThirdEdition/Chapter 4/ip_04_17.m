% MATLAB script for Illustrative Problem 17, Chapter 4
echo on;
X=wavread('speech_sample')';
mu=255; n=256;
% Differential PCM of Sequence X:
[sqnr_dpcm,X_quan_dpcm,code_dpcm]=d_pcm(X,n);
pause  % Press any key to see a plot of error in differential PCM.
plot(X-X_quan_dpcm)
title('DPCM Error');
% Mu-Law PCM PCM of sequence X:
[sqnr_mula_pcm,X_quan_mula_pcm,code_mula_pcm]=mula_pcm(X,n,mu);
pause % Press any key to see a plot of error in mu-law PCM.
figure
plot(X-X_quan_mula_pcm)
title('Mu-PCM Error');
% Uniform of Sequence X:
[sqnr_upcm,X_quan_upcm,code_upcm]=u_pcm(X,n);
pause % Press any key to see a plot of error in uniform PCM.
figure
plot(X-X_quan_upcm)
title('Uniform PCM Error');
pause % Press any key to see SQNR for Uniform PCM
sqnr_upcm
pause % Press any key to see SQNR for Mu-law PCM
sqnr_mula_pcm
pause % Press any key to see SQNR for DPCM
sqnr_dpcm
