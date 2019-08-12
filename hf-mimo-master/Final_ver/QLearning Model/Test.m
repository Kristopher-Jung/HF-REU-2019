%This file is an example run of the Serialized Adaptive Manipulator, though
%the equalizers will need to be fixed before it can be successfully used.
clc;
clear all;

erVec=SerializedAdaptiveManipulator(500, 3, 30);
erVec = erVec.';
bar(erVec,'stacked')
title('Graph of BER for With and Without Optimzation Operating in Discrete Mode')
xlabel('Signal-to-Noise Ratio')
ylabel('Bit-Error-Rate')
legend('Baseline (Without Optimization)', "Optimized Transmission 1", "Optimized Transmission 2", "Optimized Transmission 3")
j = 1;
% 
% minimums=[3 2 1 1]
% 
% maximums=[5 5 2 5]
% 
% [ret,k]=TableCreator(minimums, maximums)