function [c, ceq] = simple_constraint(x)
    nTransmit = x(5);
    nReceive = x(6);
    c = [nTransmit >= nReceive];
    ceq = [];
end