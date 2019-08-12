% MATLAB script for Illustrative Problem 4.4.
echo on ;
a=[-10,-5,-4,-2,0,1,3,5,10];
for i=1:length(a)-1
    y_actual(i)=centroid('normal',a(i),a(i+1),1e-6,0,1);
    echo off ;
end