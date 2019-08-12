% MATLAB script for Illustrative Problem 1.1.
echo on;
n=[-20:1:20];
x_actual=abs(sinc(n/2));
figure
stem(n,x_actual);