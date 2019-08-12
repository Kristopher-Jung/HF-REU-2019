function [returnVec,i] = Counter(a, maximums, returnVec, i, numParams, minimums)
%Creates a table of the total action space
    
    %Increases count
    a(1)=a(1)+1;
    
    %Checks if the count is at the threshold limits for each order then
    %adjusts the counting system accordingly
    for mk=1:(numParams-1)
        if(a(mk)==maximums(mk)+1)
        a(mk)=minimums(mk);
        a(mk+1)=a(mk+1)+1;
        end
    end
    
    %Terminates recursion if the final value is calculated
    if (a==maximums)
        for k=1:numParams
        returnVec(i, k)=a(k);
        end
        return
    end
    
    %Fills the returned table with current values
    for k=1:numParams
    returnVec(i, k)=a(k);
    end
    
    %Recursive call
    [returnVec,i] = Counter(a, maximums, returnVec, i+1, numParams, minimums);
end