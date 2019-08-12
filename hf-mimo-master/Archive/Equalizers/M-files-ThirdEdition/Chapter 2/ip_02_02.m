% Matlab script for illustrative problem 2.2

% lower and upper bounds of the Uniform random variable X:
a = 0;
b = 2;
% True values of the mean and variance of X:
m = (b-a) / 2;
v = (b-a)^2 / 12;
N = 100;            % Number of observations
idx = 0 : N;        
m_h = zeros(1,N);   % Preallocation
% Estimation of the mean and variance:
for i = 1 : N
    X = b * rand(N,1);
    m_h(i) = sum (X) / N;
end
v_h = v / N;
% Mean value of the estimates:
m_h_mean = sum (m_h,2) / N;
% The results:
disp('Press a key to see the mean value of the estimates and the true mean value of X!')
pause
disp('Mean value of the estimates is: ')
disp(m_h_mean)
disp('True mean value of X is: ')
disp(m)
disp('Press a key to view the plot of the estimates of the mean!')
pause
plot(idx, [0 m_h])
xlabel('$\hat{m}$','Interpreter','latex','fontsize',12)