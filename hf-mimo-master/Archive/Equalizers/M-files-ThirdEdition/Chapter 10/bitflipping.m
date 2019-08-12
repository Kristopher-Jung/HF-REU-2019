function [c check] = bitflipping(H,y,max_it)
%BITFLIPPING Bit-flipping algorithm for decoding LDPC codes
%   [c check] = bitflipping(H,y,max_it)
%    H: parity-check matrix of the code
%    y: channel outputs, binary-valued
%    max_it: maximum number of iterations
%    c: decoder output
%    check: is 0 if c is a codeword and is 1 if c is not a codeword
        
s = mod(y*H',2);              %Syndrome computation
it=1;                         %Iteration counter
while ((it<=max_it) && (nnz(s)~= 0)) 
  f = s*H;
  ind = find(f-max(f) == 0);
  y(ind) = mod(y(ind)+1,2);
  it = it+1;
  s = mod(y*H',2);
end
c = y;
check = nnz(s);
if (check > 0)
    check = 1;
end

