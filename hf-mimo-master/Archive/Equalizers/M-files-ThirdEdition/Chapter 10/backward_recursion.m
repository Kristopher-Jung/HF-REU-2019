% MATLAB script for Illustrative Problem 10.18
function beta=backward_recursion(gamma);
% BACKWARD_RECURSION  computing beta for 5/7 RSCC
%                     beta=backward_recursion(gamma);
%                     beta in the form of a matrix
%                     gamma is a 16XN matrix of gamma_i(sigma_(i-1),sigm_i)
N = size(gamma,2);          % Assuming gamma is given
Ns = 4;                     % Number of states
% Initialization:
beta = zeros(Ns,N);
beta(1,N) = 1;      
i = N;                      % Time index
simga_i_1 = [1 2];          % Set of states at i=N
beta(simga_i_1(1),i-1) = gamma(1,i);
beta(simga_i_1(2),i-1) = gamma(5,i);
i = N - 1;
simga_i_1 = [1 2 3 4];      % Set of states at i=N-1      
beta(simga_i_1(1),i-1) = gamma(1,N)*gamma(1,i);
beta(simga_i_1(2),i-1) = gamma(1,N)*gamma(5,i);
beta(simga_i_1(3),i-1) = gamma(5,N)*gamma(10,i);
beta(simga_i_1(4),i-1) = gamma(5,N)*gamma(14,i);
for i = N-2:-1:3
    beta(simga_i_1(1),i-1) = beta(1,i)*gamma(1,i)  + beta(3,i)*gamma(3,i);
    beta(simga_i_1(2),i-1) = beta(1,i)*gamma(5,i)  + beta(3,i)*gamma(7,i); 
    beta(simga_i_1(3),i-1) = beta(2,i)*gamma(10,i) + beta(4,i)*gamma(12,i);
    beta(simga_i_1(4),i-1) = beta(4,i)*gamma(16,i) + beta(2,i)*gamma(14,i);
end
i = 2;                      % Set of states at i=2
simga_i_1 = [1 3];
beta(simga_i_1(1),i-1) = beta(1,i)*gamma(1,i)  + beta(3,i)*gamma(3,i);
beta(simga_i_1(2),i-1) = beta(2,i)*gamma(10,i) + beta(4,i)*gamma(12,i);
i = 1;
simga_i_1 = 1;              % Set of states at i=1
beta_0(simga_i_1(1)) = beta(1,i)*gamma(1,i) + beta(3,i)*gamma(3,i);