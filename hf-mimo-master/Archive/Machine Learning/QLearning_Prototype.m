% Configure the training parameters and train a reinforcement learning
% agent. Typically, before training, you must configure your environment
% and agent. For this example, load an environment and agent that are
% already configured. The environment is a discrete cart-pole environment
% created with rlPredefinedEnv. The agent is a Policy Gradient (rlPGAgent)
% agent. For more information about the environment and agent used in this
% example, see Train PG Agent to Balance Cart-Pole System.

rng(0); % for reproducibility
load RLTrainExample.mat

% Create an environment interface.
env = rlPredefinedEnv('BasicGridWorld');

% Create a critic value function representation using a Q table derived from the environment observation and action specifications.
qTable = rlTable(getObservationInfo(env),getActionInfo(env));
critic = rlRepresentation(qTable);

% Create a Q-learning agent using the specified critic value function and an epsilon value of 0.05.
opt = rlQAgentOptions;
opt.EpsilonGreedyExploration.Epsilon = 0.05;
agent = rlQAgent(critic,opt);

% To train this agent, you must first specify training parameters using
% rlTrainingOptions. These parameters include the maximum number of
% episodes to train, the maximum steps per episode, and the conditions for
% terminating training. For this example, use a maximum of 1000 episodes
% and 500 steps per episode. Instruct the training to stop when the average
% reward over the previous five episodes reaches 500. Create a default
% options set and use dot notation to change some of the parameter values.
trainOpts = rlTrainingOptions;

trainOpts.MaxEpisodes                = 1000;
trainOpts.MaxStepsPerEpisode         = 500;
trainOpts.StopTrainingCriteria       ='AverageReward';
trainOpts.StopTrainingValue          = 500;
trainOpts.ScoreAveragingWindowLength = 5;

% During training, the train command can save candidate agents that give
% good results. Further configure the training options to save an agent
% when the episode reward exceeds 500. Save the agent to a folder called
% savedAgents.
trainOpts.SaveAgentCriteria  = 'EpisodeReward';
trainOpts.SaveAgentValue     = 500;
trainOpts.SaveAgentDirectory = 'savedAgents';

% Finally, turn off the command-line display. Turn on the Reinforcement
% Learning Episode Manager so you can observe the training progress
% visually.
trainOpts.Verbose = false;
trainOpts.Plots =   'training-progress';


% You are now ready to train the PG agent. For the predefined cart-pole
% environment used in this example. you can use plot to generate a
% visualization of the cart-pole system.
plot(env);

% When you run this example, both this visualization and the Reinforcement
% Learning Episode Manager update with each training episode. Place them
% side by side on your screen to observe the progress, and train the agent.
% (This computation can take 20 minutes or more.)
trainingInfo = train(agent,env,trainOpts);


