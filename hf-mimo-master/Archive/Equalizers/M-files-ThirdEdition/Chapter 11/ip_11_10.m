% MATLAB script for Illustrative Problem 11.10

no_bits = 10;                   % Determine the length of input vector
input = randi([0 3],1,no_bits); % Define the input as a random vector
if mod(no_bits,2) ~= 0
    input = [input 0];
end
L = size(input,2);
st_0 = 0;                       % Initial state
st_c = st_0;                    % Initialization of the current state
ant_1 = [];                     % Output of antenna 1
ant_2 = [];                     % Output of antenna 2
% Update the current state as well as outputs of antennas 1 and 2:
for i = 1:L
    st_p = st_c;
    if input(i) == 0
        st_c = 0;
    elseif input(i) == 1
        st_c = 1;
    elseif input(i) == 2
        st_c = 2;
    else
        st_c = 3;
    end
    ant_1 = [ant_1 st_p];
    ant_2 = [ant_2 st_c];
end
if st_c ~= 0
	st_p = st_c;    
    st_c = 0;
    ant_1 = [ant_1 st_p];
    ant_2 = [ant_2 st_c];
end
% Display the input vector and outputs of antennas 1 and 2:
disp(['The input sequence is:                      ', num2str(input)])
disp(['The transmitted sequence by antenna 1 is:   ', num2str(ant_1)])
disp(['The transmitted sequence by antenna 2 is:   ', num2str(ant_2)])