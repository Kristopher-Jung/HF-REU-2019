% MATLAB script for Illustrative Problem 10.17
function alpha=forward_recursion(gamma);
% FORWARD_RECURSION  computing alpha for 5/7 RSCC
%                    alpha=forward_recursion(gamma);
%                    returns alpha in the form of a matrix.
%                    gamma is a 16XN matrix of gamma_i(sigma_(i-1),sigm_i)

N = size(gamma,2);          % Assuming gamma is given
Ns = 4;                     % Number of states
% Initialization:
alpha = zeros(Ns,N);
alpha_0 = 1;            
i = 1;                      % Time index
simga_i = [1 3];            % Set of states at i=1
alpha(simga_i(1),i) = gamma(1,i);
alpha(simga_i(2),i) = gamma(3,i);
i = 2;
simga_i = [1 2 3 4];        % Set of states at i=2        
alpha(simga_i(1),i) = gamma(1,i) *alpha(1,i-1);
alpha(simga_i(2),i) = gamma(10,i)*alpha(3,i-1);
alpha(simga_i(3),i) = gamma(3,i) *alpha(1,i-1);
alpha(simga_i(4),i) = gamma(12,i)*alpha(3,i-1);
for i = 3:N-2
    alpha(simga_i(1),i) = gamma(1,i) *alpha(1,i-1) + gamma(5,i) *alpha(2,i-1);
    alpha(simga_i(2),i) = gamma(10,i)*alpha(3,i-1) + gamma(14,i)*alpha(4,i-1);
    alpha(simga_i(3),i) = gamma(3,i) *alpha(1,i-1) + gamma(7,i) *alpha(2,i-1);
    alpha(simga_i(4),i) = gamma(12,i)*alpha(3,i-1) + gamma(16,i)*alpha(4,i-1);
end
i = N - 1;                  % Set of states at i=N-1
simga_i = [1 2];
alpha(simga_i(1),i) = gamma(1,i) *alpha(1,i-1) + gamma(5,i) *alpha(2,i-1);
alpha(simga_i(2),i) = gamma(10,i)*alpha(3,i-1) + gamma(14,i)*alpha(4,i-1);
i = N;
simga_i = 1;                % Set of states at i=N
alpha(simga_i(1),i) = gamma(1,i) *alpha(1,i-1) + gamma(5,i) *alpha(2,i-1);
alpha=[[1 0 0 0]',alpha];
