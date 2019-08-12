function [alpha_t alpha_t_0] = forward_recursion_log(gamma_t)
%FORWARD_RECURSION_LOG Calculates alpha in the logarithmic domain for a 5/7 RSCC.
%        [ALPHA_T ALPHA_T_0] = FORWARD_RECURSION_LOG(GAMMA_T)
%        gamma_t: gamma in the logarithmic domain
%        alpha_t: alpha in logarithmic domain.

% Initialization:
Ns = sqrt(size(gamma_t,1)); % Number of states
N = size(gamma_t,2);
alpha_t = ones(Ns,N)*-inf;
alpha_t_0 = 0;
i = 1;                      % Time index          
simga_i = [1 3];            % Set of states at i=1
alpha_t(simga_i(1),i) = alpha_t_0 + gamma_t(1,i);
alpha_t(simga_i(2),i) = alpha_t_0 + gamma_t(3,i);
i = 2; 
simga_i = [1 2 3 4];        % Set of states at i=2
alpha_t(simga_i(1),i) = gamma_t(1,i) +alpha_t(1,i-1);
alpha_t(simga_i(2),i) = gamma_t(10,i)+alpha_t(3,i-1);
alpha_t(simga_i(3),i) = gamma_t(3,i) +alpha_t(1,i-1);
alpha_t(simga_i(4),i) = gamma_t(12,i)+alpha_t(3,i-1);
for i = 3:N-2
    alpha_t(simga_i(1),i) = max_s([gamma_t(1,i) +alpha_t(1,i-1) gamma_t(5,i) +alpha_t(2,i-1)]);
    alpha_t(simga_i(2),i) = max_s([gamma_t(10,i)+alpha_t(3,i-1) gamma_t(14,i)+alpha_t(4,i-1)]);
    alpha_t(simga_i(3),i) = max_s([gamma_t(3,i) +alpha_t(1,i-1) gamma_t(7,i) +alpha_t(2,i-1)]);
    alpha_t(simga_i(4),i) = max_s([gamma_t(12,i)+alpha_t(3,i-1) gamma_t(16,i)+alpha_t(4,i-1)]);
end
i = N - 1; 
simga_i = [1 2];            % Set of states at i=N-1
alpha_t(simga_i(1),i) = max_s([gamma_t(1,i) +alpha_t(1,i-1) gamma_t(5,i) +alpha_t(2,i-1)]);
alpha_t(simga_i(2),i) = max_s([gamma_t(10,i)+alpha_t(3,i-1) gamma_t(14,i)+alpha_t(4,i-1)]);
i = N; 
simga_i = 1;                % Set of states at i=N
alpha_t(simga_i(1),i) = max_s([gamma_t(1,i) +alpha_t(1,i-1) gamma_t(5,i) +alpha_t(2,i-1)]);