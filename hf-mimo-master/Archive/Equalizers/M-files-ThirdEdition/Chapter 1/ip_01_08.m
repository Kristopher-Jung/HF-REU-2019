% MATLAB script for Illustrartive Problem 1.8.
ts=0.001;
fs=1/ts;
t=[0:ts:10];
x=cos(2*pi*47*t)+cos(2*pi*219*t);
p=spower(x);
Hs = spectrum.welch('hann',1024,0);
psd(Hs,x,'Fs',fs,'NFFT',1024);
p
