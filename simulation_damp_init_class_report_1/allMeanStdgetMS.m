function [avg,standev] = allMeanStdgetMS(x)
i = zeros(11,1);
index = 0;
arrayExt = [-1;x;0];
for val = 2:length(arrayExt)
    if arrayExt(val-1)~=0 && arrayExt(val)==0
        index = index + 1;
        i(index) = val-1;
    end
end
iLength = diff(i);
avg = mean(iLength);
standev = std(iLength);
end