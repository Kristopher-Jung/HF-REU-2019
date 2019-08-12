% MATLAB script for Illustrative Problem 10.4.
echo on
SNR_db=[-13:0.5:13];
SNR=10.^(SNR_db/10);
c_hard=1-entropy2(q(SNR));
for i=1:53
    f(i)=quad('il3_8fun',SNR(i)-5,SNR(i)+5,1e-3,[],SNR(i));
    c_soft(i)=f(i);
    echo off ;
end
echo on ;
pause % Press a key to see the capacity curves.
semilogx(SNR,c_soft,SNR,c_hard)