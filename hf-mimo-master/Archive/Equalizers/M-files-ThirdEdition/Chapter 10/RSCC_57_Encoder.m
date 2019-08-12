function [c_sys,c_pc]=RSCC_57_Encoder(u);
% RSCC_57_Encoder  Encoder for 5/7 RSCC
%                  [c_sys,c_pc]=RSCC_57_Encoder(u)
%                  returns c_sys the systematic bits and
%                  c_pc, the parity check bits of the code
%                  when input is u and the encoder is
%                  initiated at 0-state.
u = [0 1 1 1 0 0 1 0 0 1 1 0 0 1 0 0 1 1 1 1];
L = length(u);
l = 1;
% Initializing the values of the shift register:
r1 = 0;
r2 = 0;
r3 = 0;
while l <= L
    u_t = u(l);
    % Generating the systematic bits:
    c1(l) = u_t;
    % Updating the values of the shift register:
    r1_t = mod(mod(r3 + r2,2) + u_t,2);
    r3 = r2;
    r2 = r1;
    r1 = r1_t;
    % Generating the parity check bits:
    c2(l) = mod(r1 + r3,2);
    l = l + 1;
end
c_cys=c1;
c_pc=c2;
