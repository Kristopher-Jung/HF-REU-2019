%% Q-learning with epsilon-greedy exploration Algorithm for Deterministic Cleaning Robot V1
%  Matlab code : Reza Ahmadzadeh
%  email: reza.ahmadzadeh@iit.it
%  March-2014
%% The deterministic cleaning-robot MDP
% a cleaning robot has to collect a used can also has to recharge its
% batteries. the state describes the position of the robot and the action
% describes the direction of motion. The robot can move to the left or to
% the right. The first (1) and the final (6) states are the terminal
% states. The goal is to find an optimal policy that maximizes the return
% from any initial state. Here the Q-learning epsilon-greedy exploration
% algorithm (in Reinforcement learning) is used.
% Algorithm 2-3, from:
% @book{busoniu2010reinforcement,
%   title={Reinforcement learning and dynamic programming using function approximators},
%   author={Busoniu, Lucian and Babuska, Robert and De Schutter, Bart and Ernst, Damien},
%   year={2010},
%   publisher={CRC Press}
% }
% notice: the code is written in 1-indexed instead of 0-indexed
%
% V1 the initial evaluation of the algorithm 
%
%% this is the main function including the initialization and the algorithm
% the inputs are: initial Q matrix, set of actions, set of states,
% discounting factor, learning rate, exploration probability,
% number of iterations, and the initial state.
function qlearning
% learning parameters
gamma = 0.5;    % discount factor  % TODO : we need learning rate schedule
alpha = 0.5;    % learning rate    % TODO : we need exploration rate schedule
epsilon = 0.9;  % exploration probability (1-epsilon = exploit / epsilon = explore)
% states
state = [1:4];
% actions
max_snr=25;
max_sr=20e6;
max_sp=5;
max_qp=4;
max_fr=10;
max_ff=10;

 action_space={1:max_snr; 10e6:max_sr; 1:max_sp; 1:max_fr; 1:max_ff};
%action_space=[[1:5]; [1:5]; [1:5]; [1:5]; [1:5]]
% state_idx = 1;  % the initial state to begin from
 %Limited to -1 to 1 discrete to either explore or exploit
% initial Q matrix
parameter_opt=[[1:5]; [1:5]; [1:5]; [1:5]];

outcome = 1;
%% the main loop of the algorithm
for state_idx = 1:4
    action = [action_space{state_idx}];
    Q = zeros(length(state),length(action));
    K = 100;     % maximum number of the iterations
for k = 1:K
    disp(['iteration: ' num2str(k)]);
    r=rand; % get 1 uniform random number
    x=sum(r>=cumsum([0, 1-epsilon, epsilon])); % check it to be in which probability area
    
    % choose either explore or exploit
    if x == 1   % exploit
        [~,umax]=max(Q(state_idx,:));
        current_action = action(umax);
    else        % explore
        current_action=datasample(action,1); % choose 1 action randomly (uniform random distribution)
    end
    
    action_idx = find(action==current_action); % id of the chosen action
    % observe the next state and next reward ** there is no reward matrix
    
    [next_state,next_reward] = model(state(state_idx),action(action_idx), outcome); %ENV
    next_state_idx = find(state==next_state);  % id of the next state %Update state
    % print the results in each iteration
    disp(['current state : ' num2str(state(state_idx)) ' next state : ' num2str(state(next_state_idx)) ' taken action : ' num2str(action(action_idx))]); 
    disp([' next reward : ' num2str(next_reward)]);
    % update the Q matrix using the Q-learning rule
    Q(state_idx,action_idx) = Q(state_idx,action_idx) + alpha * (next_reward + gamma* max(Q(next_state_idx,:)) - Q(state_idx,action_idx)); %Bellman
    % if the robot is stuck in terminals
%     if (next_state_idx == 6 || next_state_idx == 1) %Set Limits
%         state_idx = datasample(2:length(state)-1,1); % we just restart the episode with a new state
%     else
%         state_idx = next_state_idx;
%     end
%     disp(Q);  % display Q in each level
end
% display the final Q matrix
disp('Final Q matrix : ');
% disp(Q);
%[C,I]=max(Q,[],2);     
% % finding the max values
[C,I] = maxk(Q(1,:),5);
I = I.';
disp('Q(optimal):');
disp(C);
disp('Optimal Policy'); 
disp('*');
result=[action(I(1,1));action(I(2,1));action(I(3,1));action(I(4,1));action(I(5,1))];
disp(result);
disp('*');
parameter_opt(state_idx,:)=result;
end
disp(parameter_opt)
end


%% This function is used as an observer to give the next state and the next reward using the current state and action
function [next_state,r] = model(x,u, outcome) %state, action
    next_state=x;
    sample_rate=10e6;
    nRecieve=2;
    nTransmit=2;
    signal_power=1;
    PSK_order=4;
    nframes=10;
    FFT_len_power=10;
    snr=25;
    
    %Select State by Parameter
    %snr
    if(x==1)
    snr=u;
    end
    
    %sample_rate
    if(x==2)
    sample_rate=u;
    end
    
    
    %signal_power
    if(x==3)
    signal_power=u;
    end
    
%     %PSK_Order
%     if(x==4)
%     PSK_order=u;
%     end
    
    %nframes
    if(x==4)
    nframes=u;
    end
    
    [E, P, C, EVM]=MIMO_PARAMATIZED_FUNC(snr, sample_rate, nRecieve, nTransmit, signal_power, PSK_order, nframes, FFT_len_power);
    if outcome==1
        Er=E(1)+E(2);
        r=1/Er;
    else
        r=C;
    end
end
