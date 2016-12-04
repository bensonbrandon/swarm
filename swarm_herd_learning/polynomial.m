function [ out ] = polynomial( W,x )
out = 0;
for i = 1:length(W)
    out = out + W(i)*x.^(i-1);
end
end

