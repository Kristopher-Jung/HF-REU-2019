% MATLAB script foar Illustrative Problem 9.5

N = 1000;           % Number of samples
M = 50;             % Length of the autocorrelation function
p = [0.9 0.99];     % Pole positions
w = 1/sqrt(2)*(randn(1,N) + 1i*randn(1,N)); % AWGN sequence
% Preallocation for speed:
c = zeros(length(p),N);
Rx = zeros(length(p),M+1);
Sx = zeros(length(p),M+1);
for i = 1:length(p)
    for n = 3:N
        c(i,n) = 2*p(i)*c(n-1) - power(p(i),2)*c(n-2) + power((1-p(i)),2)*w(n);
    end
    % Calculation of autocorrelations and power spectra:
    Rx(i,:) = Rx_est(c(i,:),M);
    Sx(i,:)=fftshift(abs(fft(Rx(i,:))));
    echo off
end
echo on
% Plot the results:
subplot(3,2,1)
plot(real(c(1,:)))
axis([0 N -max(abs(real(c(1,:)))) max(abs(real(c(1,:))))])
title('\it{p} = 0.9')
xlabel('\it{n}')
ylabel('\it{c_{nr}}')
subplot(3,2,2)
plot(real(c(2,:)))
axis([0 N -max(abs(real(c(2,:)))) max(abs(real(c(2,:))))])
title('\it{p} = 0.99')
xlabel('\it{n}')
ylabel('\it{c_{nr}}')
subplot(3,2,3)
plot(imag(c(1,:)))
axis([0 N -max(abs(imag(c(1,:)))) max(abs(imag(c(1,:))))])
title('\it{p} = 0.9')
xlabel('\it{n}')
ylabel('\it{c_{ni}}')
subplot(3,2,4)
plot(imag(c(2,:)))
axis([0 N -max(abs(imag(c(2,:)))) max(abs(imag(c(2,:))))])
title('\it{p} = 0.99')
xlabel('\it{n}')
ylabel('\it{c_{ni}}')
subplot(3,2,5)
plot(abs(c(1,:)))
axis([0 N 0 max(abs(c(1,:)))])
title('\it{p} = 0.9')
xlabel('\it{n}')
ylabel('\it{|c_n |}')
subplot(3,2,6)
plot(abs(c(2,:)))
axis([0 N 0 max(abs(c(2,:)))])
title('\it{p} = 0.99')
xlabel('\it{n}')
ylabel('\it{|c_n |}')

figure
subplot(2,2,1)
plot(abs(Rx(1,:)))
axis([0 M 0 max(abs(Rx(1,:)))])
title('\it{p} = 0.9')
xlabel('\it{n}'); ylabel('\it{|R_{c}(n)|}')
subplot(2,2,2)
plot(abs(Rx(2,:)))
title('\it{p} = 0.99')
xlabel('\it{n}'); ylabel('\it{|R_{c}(n)|}')
axis([0 M 0 max(abs(Rx(2,:)))])
subplot(2,2,3)
plot(Sx(1,:))
title('\it{p} = 0.9')
xlabel('\it{f}'); ylabel('\it{S_{c}(f)}')
axis([0 M 0 max(abs(Sx(1,:)))])
subplot(2,2,4)
plot(Sx(2,:))
title('\it{p} = 0.99')
xlabel('\it{f}'); ylabel('\it{S_{c}(f)}')
axis([0 M 0 max(abs(Sx(2,:)))])