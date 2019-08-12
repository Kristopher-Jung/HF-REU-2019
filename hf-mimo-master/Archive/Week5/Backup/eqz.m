function [H_est, y] = eqz(eq, Algorithm, Rx, Tx)
sz = size(Tx);
y = [];
switch Algorithm
    case 'LS_ZF'
        H_est=pinv(Tx)*Rx;
        y=Rx/H_est;
    case 'CMA'
        for i = 1:sz(2)
            y = [y, eq(Rx(:,i))];
        end
        eq.reset;
        H_est=pinv(Tx)*Rx;
    otherwise
        for i = 1:sz(2)
            y = [y, eq(Rx(:,i), Tx(1:sz(1)/10,i))];
        end
        eq.reset;
        H_est=pinv(Tx)*Rx;
end
end