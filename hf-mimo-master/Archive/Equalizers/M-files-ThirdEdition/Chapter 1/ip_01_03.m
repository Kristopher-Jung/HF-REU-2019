% MATLAB script for Illustrative Problem 1.3.
echo on
fnct='normal';
a=-6;
b=6;
n=24;
tol=1e-6;
xx=fseries(fnct,a,b,n,tol,0,1);
xx1=xx(n+1:-1:2);
xx1=[conj(xx1),xx];
absxx1=abs(xx1);
pause % Press any key to see a plot of the magnitude.
n1=[-n:n];
stem(n1,absxx1)
title('The Discrete Magnitude Spectrum')
phasexx1=angle(xx1);
pause % Press any key to see a plot of the phase.
stem(n1,phasexx1)
title('The Discrete Phase Spectrum')