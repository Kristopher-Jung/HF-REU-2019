% MATLAB script for Illustrative Problem 8.1

M = 50;
m = 0:M-1;
phi_k = 2*pi*rand;
phi_j = 2*pi*rand;
% The sampled signals:
x_k = sin(4*pi*m/5+phi_k);
n = 1;
x_j_1 = sin(4*pi*m/5+2*pi*m*n/M+phi_j);
n = 2 ;
x_j_2 = sin(4*pi*m/5+2*pi*m*n/M+phi_j);
n = 3 ;
x_j_3 = sin(4*pi*m/5+2*pi*m*n/M+phi_j);
% Investigating the orthogonality of the sampled signals:
Sum1 = sum(x_k.*x_j_1);
% Displaying the results:
disp(['The result of the computation for n=1 is:    ',num2str(Sum1)])
Sum2 = sum(x_k.*x_j_2);
disp(['The result of the computation for n=2 is:    ',num2str(Sum2)])
Sum3 = sum(x_k.*x_j_3);
disp(['The result of the computation for n=3 is:    ',num2str(Sum3)])