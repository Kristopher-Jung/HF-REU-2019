
chan = stdchan('iturHFMQ',20e6,1);
data = randi([0 3],10000,1);
y = chan(data)
