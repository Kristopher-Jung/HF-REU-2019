% MATLAB script for Illustrative Problem 12.5

L = 1023;                           % Sequence length
s = 1;
var = 10;                           % Noise variance
sh_r = [1 zeros(1,9)];              % Initialization of the shift register
% Initialization for speed:
output = zeros(1,L);
Rc = zeros(1,L);
y = zeros(1,L);
% Generating the sequence at the shift register output:
for i = 1 : L
    output(i) = sh_r(1);
    temp = mod(sh_r(1)+sh_r(8),2);
    for j = 1 : 9
        sh_r(j) = sh_r(j+1);
    end
   sh_r(10) = temp; 
end
% The bipolar sequence:
c = 2*output - 1;
for m = 0 : L-1
    for n = 1 : L
        if n+m>L
            Rc(m+1) = Rc(m+1) + c(n)*c(mod(n+m,L));
        else
            Rc(m+1) = Rc(m+1) + c(n)*c(n+m);
        end
    end
end
r = s*c + sqrt(var)*randn(1,L);     % Output of the chip matched filter
% Calculation of the crosscorrelation output:
for n = 1 : L
    y(n) = sum(r(1:n).*c(1:n));
end
% Plot the results for parts 2 & 3:
disp('Press a key to see the plot for part 2.')
pause
plot(r)
axis([0 L -max(abs(r)) max(abs(r))])
xlabel('k')
ylabel('r_k')
disp('Press a key to see the plot for part 3.')
pause
figure
plot(y)
axis([0 L min(y) max(y)])
xlabel('n')
ylabel('y_n')