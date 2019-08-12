function penalty = generative_testing(...
    input, PSK_order_power, FFT_len_power,...
    nframes, nTransmit, nReceive,...
    signal_power, RT)

snr = input{1};
Algorithm = input{2};
step_size = input{3};
num_fts = input{4};
num_fbts = input{5};
FF = 0.1*input{6};
data = input{7};
chan = input{8};

switch Algorithm
    case 1
        Algorithm = 'LS_ZF';
    case 2
        Algorithm = 'LMS';
    case 3
        Algorithm = 'RLS';
    case 4
        Algorithm = 'CMA';
end

penalty = MIMO_PARAMATIZED_FUNC(...
    data, chan, snr, ...
    nTransmit, nReceive, ...
    signal_power, PSK_order_power, nframes, FFT_len_power, ...
    Algorithm, num_fts, num_fbts, step_size, RT, FF);
end
