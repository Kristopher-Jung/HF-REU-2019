% MATLAB script for Illustrative Problem 10.13.
k0=2;
g=[0 0 1 0 1 0 0 1;0 0 0 0 0 0 0 1;1 0 0 0 0 0 0 1];
input=[1 0 0 1 1 1 0 0 1 1 0 0 0 0 1 1 1];
output=cnv_encd(g,k0,input);