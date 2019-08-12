function qlearning
% learning parameters
gamma = 0.5;    % discount factor  % TODO : we need learning rate schedule
alpha = 0.5;    % learning rate    % TODO : we need exploration rate schedule
epsilon = 0.9;  % exploration probability (1-epsilon = exploit / epsilon = explore)

% starting inputs
curr_params = [1 1 1 1 1 1];

% states
state = 1:6;

% actions
max_refTap=1;
max_nFwdTaps=15;
max_nFdbkTaps=15;
max_stepsz=100; % *0.00001
max_forgfec=99; % *0.01
max_alg=3;

% action spaces
action_space={1:max_refTap; 1:max_nFwdTaps; 2:max_nFdbkTaps; 1:max_stepsz; 1:max_forgfec; 1:max_alg};

% initial Q matrix
parameter_opt=[1:6; 1:6; 1:6; 1:6; 1:6; 1:6];

outcome = 1;
%% the main loop of the algorithm
for state_idx = 1:6
    action = [action_space{state_idx}];
    Q = zeros(length(state),length(action));
    K = 100;     % maximum number of the iterations
    next_state_idx = state_idx;
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
        
        [new_params, next_state,next_reward] = model(curr_params, state(next_state_idx),action(action_idx), outcome); %ENV
        curr_params = new_params; % update param set.
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
    %display the final Q matrix
%     disp('Final Q matrix : ');
%     disp(Q);
%     [C,I]=max(Q,[],2);
    % finding the max values
%     [C,I] = maxk(Q(1,:),5);
%     I = I.';
%     disp('Q(optimal):');
%     disp(C);
%     disp('Optimal Policy');
%     disp('*');
%     result=[action(I(1,1));action(I(2,1));action(I(3,1));action(I(4,1));action(I(5,1))];
%     disp(result);
%     disp('*');
%     parameter_opt(state_idx,:)=result;
end
% disp(parameter_opt)
end


%% This function is used as an observer to give the next state and the next reward using the current state and action
function [new_params, next_state,r] = model(curr_params, x,u, outcome) %state, action
numSymbols = 1e3; % number of symbols transmitted in total.
M = 4;
SNR = 15;
data = randi([0 M-1],numSymbols,2); % Initialize random data for training equalizer with current configs
switch M
    % Picking low Sampling Rates standards
    % for the current modulation scheme in 6kHz bandwidth.
    case 2
        sr = 3.2e3;
    case 4
        sr = 6.4e3;
    case 8
        sr = 9.6e3;
    case 16
        sr = 12.8e3;
    case 32
        sr = 16e3;
    case 64
        sr = 19.2e3;
end
% Initialize Watterson MIMO Channel assuming 2x2 MIMO
chan = comm.MIMOChannel(...
    'SampleRate',sr,...
    'FadingDistribution','Rayleigh',...
    'AveragePathGains',[0 0],...
    'PathDelays',[0 0.5] * 1e-3,...
    'DopplerSpectrum',doppler('Gaussian', 0.1/2),...
    'TransmitCorrelationMatrix', eye(2), ...
    'ReceiveCorrelationMatrix', eye(2));

next_state=x;
switch x
    case 1
        new_params = [u, curr_params(2), curr_params(3), curr_params(4),curr_params(5),curr_params(6)];
    case 2
        new_params = [curr_params(1), u, curr_params(3), curr_params(4),curr_params(5),curr_params(6)];
    case 3
        new_params = [curr_params(1), curr_params(2), u, curr_params(4),curr_params(5),curr_params(6)];
    case 4
        new_params = [curr_params(1), curr_params(2), curr_params(3), u*0.00001,curr_params(5),curr_params(6)];
    case 5
        new_params = [curr_params(1), curr_params(2), curr_params(3), curr_params(4),u*0.01,curr_params(6)];
    case 6
        new_params = [curr_params(1), curr_params(2), curr_params(3), curr_params(4),curr_params(5),u];
end

display(new_params);

e = objectiveFunction(data, chan, M, SNR, new_params);
if outcome==1
    r=-e;
end
end
