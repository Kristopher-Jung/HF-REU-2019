% MATLAB script for Illustrative Problem 2.5.
echo on
% first part
Sx1=[ones(1,32)];
Rx1=ifft(Sx1,32);
% second part
Sx2=[ones(1,16),zeros(1,224),ones(1,16)];
Rx2=ifft(Sx2,256);
% plotting commands follow