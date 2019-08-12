% MATLAB script for Illustrative Problem 18, Chapter 4
echo on
X = wavread('speech_sample')';
XXX = lin_intplt3p(X);
delta=0.034;
[XXX_quan_dm, sqnr_dm] = delta_mod(XXX,delta);
QE_dm = XXX-XXX_quan_dm;
levels = 16;
[sqnr_dpcm,X_quan_dpcm,code_dpcm] = d_pcm(X,levels);
QE_dpcm = X-X_quan_dpcm;
pause % Press any key to see a plot of error in DM.
figure
plot(QE_dm,'-k')
title('Error in delta modulator')
pause % Press any key to see a plot of error in DPCM.
figure
plot(QE_dpcm,'-k')
title('Error in DPCM')
pause % Press any key to see values of SQNR for DM.
sqnr_dm
pause % Press any key to see values of SQNR for DPCM.
sqnr_dpcm
