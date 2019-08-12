function [next_state,r] = Enviornment(x,u, p, ret)
%The enviroment for the q-learning to process the data through and
%calculate reward.

%Maintains state
next_state=x;

%Switch parameters and optimizers depending on equalizer
switch (p{6})
    case 1
        wl=ret(u,1);
        
        tx=p{1};
        rx=p{2};
        M=p{3};
        pilot_freq=p{4};
        var=p{5};
        equalizer=p{6};
        
    case 2
        wl=ret(u,1);
        
        tx=p{1};
        rx=p{2};
        M=p{3};
        pilot_freq=p{4};
        var=p{5};
        equalizer=p{6};
        
    case 3
        wl=ret(u,1);
        var=ret(u, 2)/10;
        
        tx=p{1};
        rx=p{2};
        M=p{3};
        pilot_freq=p{4};
        placeholder=p{5};
        equalizer=p{6};
end

%Caclulate the error
e=objective_fun_q(tx,rx, M, pilot_freq, [equalizer, wl, var]);

%Return reciprocal of error as reward
r=1/e;

end