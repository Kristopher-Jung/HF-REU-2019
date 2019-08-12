function q = QLearn(data, gamma, alpha, epsilon, iterations, params, minimums, maximums)
%% this is the main function including the initialization and the algorithm
% the inputs are: initial Q matrix, set of actions, set of states,
% discounting factor, learning rate, exploration probability,
% number of iterations, and the initial state.
% learning parameters
% gamma = 0.5;    % discount factor  % TODO : we need learning rate schedule
% alpha = 0.5;    % learning rate    % TODO : we need exploration rate schedule
% epsilon = 0.9;  % exploration probability (1-epsilon = exploit / epsilon = explore)
% states



%Define state-spaace
state = [1:1];

[ret, dim]=TableCreator(minimums, maximums);

%Define Action Space
action_space={1:dim(1)};

%% the main loop of the algorithm
for state_idx = 1:1
    action = [action_space{state_idx}];
    Q = zeros(length(state),length(action));
    K = iterations;     % maximum number of the iterations
for k = 1:K
    %disp(['iteration: ' num2str(k)]);
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
    
    [next_state,next_reward] = Enviornment(state(state_idx),action(action_idx), params, data, ret); %ENV
    next_state_idx = find(state==next_state);  % id of the next state %Update state
    % print the results in each iteration
    %disp(['current state : ' num2str(state(state_idx)) ' next state : ' num2str(state(next_state_idx)) ' taken action : ' num2str(action(action_idx))]); 
   % disp([' next reward : ' num2str(next_reward)]);
    % update the Q matrix using the Q-learning rule
    Q(state_idx,action_idx) = Q(state_idx,action_idx) + alpha * (next_reward + gamma* max(Q(next_state_idx,:)) - Q(state_idx,action_idx)); %Bellman
end
% display the final Q matrix
% disp('Final Q matrix : ');
[C,I] = maxk(Q(1,:),5);
I = I.';
% disp('Q(optimal):');
% disp(C);
% disp('Optimal Policy'); 
% disp('*');
%result=[action(I(1,1)); action(I(2,1));action(I(3,1));action(I(4,1));action(I(5,1))];
disp('*');

q=ret(action(I(1,1)),:)

end
end


