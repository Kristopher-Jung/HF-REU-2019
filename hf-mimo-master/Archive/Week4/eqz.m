function [H_est, y] = eqz(equalizer, Algorithm, Rx, Tx)
sz = size(Tx);
y = [];
H_est = [];
switch Algorithm
    case 'LS_ZF'
        H_est=pinv(Tx)*Rx;
        y=Rx/H_est;
    case 'CMA'
        for i = 1:sz(2)
            y = [y, equalizer(Rx(:,i))];
            H_est = [H_est, pinv(Tx)*Rx];
        end
    otherwise
        for i = 1:sz(2)
            y = [y, equalizer(Rx(:,i), Tx(:,i))];
            H_est = [H_est, pinv(Tx)*Rx];
        end
end
end