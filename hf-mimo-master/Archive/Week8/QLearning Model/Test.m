%This file is an example run of the Serialized Adaptive Manipulator, though
%the equalizers will need to be fixed before it can be successfully used.
clc;
clear all;

SerializedAdaptiveManipulator(500, 10, 10)
% 
% minimums=[3 2 1 1]
% 
% maximums=[5 5 2 5]
% 
% [ret,k]=TableCreator(minimums, maximums)