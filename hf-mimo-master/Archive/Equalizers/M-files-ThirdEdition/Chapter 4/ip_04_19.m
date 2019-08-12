% MATLAB scriptfor Illustrative Problem 19, Chapter 4.
X = wavread('speech_sample')';
XXX = lin_intplt3p(X);
delta_in=0.01;
K=1.5;
[X_quan_adm, sqnr_adm] = adpt_delta_mod(XXX,K,delta_in);
QE_adm=XXX-X_quan_adm;
pause % Press any key to see a plot of error in ADM.
figure
plot(QE_adm,'-k')
title('Error in adaptive delta modulator')
pause % Press any key to see values of SQNR for ADM.
sqnr_adm