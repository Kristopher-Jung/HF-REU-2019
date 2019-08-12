% MATLAB script for Illustrative Problem 6.6

N=1000;                 % Length of sequence
M=100;                  % Autocorrelation function length
Fs=N;                   % Sampling frequency
NFFT = 2^nextpow2(N);   % Next power of 2 from length of y
f=Fs/2*linspace(-0.5,0.5,NFFT/2+1);
F=1/2*linspace(-0.5,0.5,NFFT/2+1);
p=0.99;
d=5;                    % Time delay between the two paths
% Preallocation for speed:
b1=zeros(1,N); b2=zeros(1,N); c=zeros(1,N);
% Input WGN sequence
w=randn(2,N);
% Output sequences:
b1(1)=(1-p)^2*w(1,1);
b1(2)=2*p*b1(1)+(1-p)^2*w(1,2);
b2(1)=(1-p)^2*w(2,1);
b2(2)=2*p*b2(1)+(1-p)^2*w(2,2);
u=1:M+1;
for n=3:N
    b1(n)=2*p*b1(n-1)-p^2*b1(n-2)+(1-p)^2*w(1,n);
    b2(n)=2*p*b2(n-1)-p^2*b2(n-2)+(1-p)^2*w(2,n);
end
% Channel impulse response:
for n=1:5
    c(n)=b1(n);
end
for n=6:N
    c(n)=b1(n)+b2(n-d);
end
% Autocorrelation calculations:
Rx_b1=Rx_est(b1,M);
Rx_b2=Rx_est(b2,M);
Rx_c =Rx_est(c,M);
% Power spectra calculations:
Sx_b1=fftshift(abs(fft(Rx_b1,NFFT)/N));
Sx_b2=fftshift(abs(fft(Rx_b2,NFFT)/N));
Sx_c =fftshift(abs(fft(Rx_c,NFFT)/N));
% Calculation of H(f):
z=exp(1i*2*pi*F);
num=(1-p)^2;
denum=(1-p*z.^-1).^2;
H=num./denum;
% Plot the results:
subplot(3,2,1)
plot(Rx_b1)
axis([0 M min(Rx_b1) max(Rx_b1)])
xlabel('Time (sec)')
legend('R_x(b_1)')
subplot(3,2,2)
plot(f,Sx_b1(NFFT/4:3*NFFT/4))
xlabel('Frequency (Hz)')
axis([min(f) max(f) min(Sx_b1) max(Sx_b1)])
legend('S_x(b_1)')
subplot(3,2,3)
plot(Rx_b2)
axis([0 M min(Rx_b2) max(Rx_b2)])
xlabel('Time (sec)')
legend('R_x(b_2)')
subplot(3,2,4)
plot(f,Sx_b2((NFFT/4:3*NFFT/4)))
xlabel('Frequency (Hz)')
axis([min(f) max(f) min(Sx_b2) max(Sx_b2)])
legend('S_x(b_2)')
subplot(3,2,5)
plot(Rx_c)
axis([0 M min(Rx_c) max(Rx_c)])
xlabel('Time (sec)')
legend('R_x(c)')
subplot(3,2,6)
plot(f,Sx_c((NFFT/4:3*NFFT/4)))
axis([min(f) max(f) min(Sx_c) max(Sx_c)])
xlabel('Frequency (Hz)')
legend('S_x(c)')
figure
plot(f,abs(H).^2)
axis([min(f) max(f) min(abs(H).^2) max(abs(H).^2)])
xlabel('Frequency (Hz)')
legend('|H(f)|^2')