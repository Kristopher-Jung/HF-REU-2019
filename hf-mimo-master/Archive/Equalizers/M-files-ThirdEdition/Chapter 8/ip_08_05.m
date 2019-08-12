% MATLAB script for Illustrative Problem 8.5

T = 1;
k = 0 : 5;
f_k = k/T;
f = 0 : 0.01*4/T : 4/T;
U_k_abs = zeros(length(k),length(f));
for i = 1 : length(k)
    U_k_abs(i,:) = abs(sqrt(T/2)*(sinc((f-f_k(i))*T) + sinc((f+f_k(i))*T)));
    U_k_norm(i,:) = U_k_abs(i,:)/max(U_k_abs(i,:));
end
U_k_dB = 10*log10(U_k_norm);
plot(f,U_k_dB(1,:),'black',f,U_k_dB(2,:),'black',f,U_k_dB(3,:),'black',...
    f,U_k_dB(4,:),'black',f,U_k_dB(5,:),'black',f,U_k_dB(6,:),'black')
axis([min(f) max(f) -180 20])
xlabel('f')
ylabel('|U_k(f)| (dB)')