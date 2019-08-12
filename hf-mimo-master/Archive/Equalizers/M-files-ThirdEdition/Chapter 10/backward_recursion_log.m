function beta_t= backward_recursion_log(gamma_t)
%BACKWARD_RECURSION_LOG Calculates beta's in the logarithmic domain for a 5/7 RSCC.
%   BETA_T = BACKWARD_RECURSION_LOG(GAMMA_T)
%            gamma_t: gamma in the logarithmic domain
%            beta_t: beta in logarithmic domain.

% Initialization:
Ns = sqrt(size(gamma_t,1)); % Number of states
N = size(gamma_t,2);
beta_t = ones(Ns,N)*-inf;
beta_t(1,N) = 0;
i = N;                      % Time index
simga_i_1 = [1 2];          % Set of states at i=N
beta_t(simga_i_1(1),i-1) = beta_t(1,N)+gamma_t(1,i);
beta_t(simga_i_1(2),i-1) = beta_t(1,N)+gamma_t(5,i);
i = N - 1;
simga_i_1 = [1 2 3 4];      % Set of states at i=N-1
beta_t(simga_i_1(1),i-1) = gamma_t(1,N)+gamma_t(1,i);
beta_t(simga_i_1(2),i-1) = gamma_t(1,N)+gamma_t(5,i);
beta_t(simga_i_1(3),i-1) = gamma_t(5,N)+gamma_t(10,i);
beta_t(simga_i_1(4),i-1) = gamma_t(5,N)+gamma_t(14,i);
for i = N-2:-1:3
    beta_t(simga_i_1(1),i-1) = max_s([beta_t(1,i)+gamma_t(1,i)  beta_t(3,i)+gamma_t(3,i)]);
    beta_t(simga_i_1(2),i-1) = max_s([beta_t(1,i)+gamma_t(5,i)  beta_t(3,i)+gamma_t(7,i)]);
    beta_t(simga_i_1(3),i-1) = max_s([beta_t(2,i)+gamma_t(10,i) beta_t(4,i)+gamma_t(12,i)]);
    beta_t(simga_i_1(4),i-1) = max_s([beta_t(4,i)+gamma_t(16,i) beta_t(2,i)+gamma_t(14,i)]);
end
i = 2;
simga_i_1 = [1 3];          % Set of states at i=2
beta_t(simga_i_1(1),i-1) = max_s([beta_t(1,i)+gamma_t(1,i)  beta_t(3,i)+gamma_t(3,i)]);
beta_t(simga_i_1(2),i-1) = max_s([beta_t(2,i)+gamma_t(10,i) beta_t(4,i)+gamma_t(12,i)]);
i = 1;
simga_i_1 = 1;              % Set of states at i=1
beta_t_0(simga_i_1(1)) = max_s([beta_t(1,i)+gamma_t(1,i) beta_t(3,i)+gamma_t(3,i)]);