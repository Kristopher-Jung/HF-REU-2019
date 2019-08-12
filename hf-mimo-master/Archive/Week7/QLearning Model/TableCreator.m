function [returnVec, dimensionality]= TableCreator(lowerLimits,upperLimits)
%Runs the function that creates a table of the total action space
    
    numParams=size(lowerLimits,2);
    r=ones([prod(upperLimits) numParams]);
    
    for i=1:numParams
        r(1,i)=lowerLimits(i);
    end
    
    %Returns the table and dimensionality of it
    [returnVec,k] = Counter(lowerLimits, upperLimits, r, 2, numParams, lowerLimits);
    dimensionality=[k numParams];
end