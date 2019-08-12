% MATLAB script for Illustrative Problem 9.3

N = 20000;                              % Number of samples
x = 0:0.1:5;
sigma = 1;                              % Rayleigh parameter
u = rand(1,N);
r = sigma*sqrt(-2*log(u));              % Rayleigh distributed random data
r_ac = x/sigma^2.*exp(-(x/sigma).^2/2); % Rayleigh PDF
% Plot the results:
subplot(2,1,1)
hist(r,x);
xlabel('(a) Histogram for N=20000 samples')
axis([0 5 0 1500])
subplot(2,1,2)
plot(x,r_ac)
xlabel('(b) Rayleigh PDF')