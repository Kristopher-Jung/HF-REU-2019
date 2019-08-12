% MATLAB script for Illustrative Problem 10.3.
echo on
SNR_db=[-20:0.2:20];
SNR=10.^(SNR_db/10);
for i=1:201
    f(i)=quad('il3_8fun',SNR(i)-5,SNR(i)+5,1e-3,[],SNR(i));
    c(i)=f(i);
    echo off ;
end
echo on ;
pause % Press a key to see capacity vs. SNR plot.
semilogx(SNR,c)
title('Capacity versus SNR in binary input AWGN channel')
xlabel('SNR')
ylabel('Capacity (bits/transmission)')