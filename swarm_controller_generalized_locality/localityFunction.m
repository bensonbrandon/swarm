function [force] = localityFunction(dist,agentSize,lambda)
if dist<agentSize
    force = dist/agentSize;
else
    %force = exp(-((dist/agentSize)^2 -1)*(1/lambda)^2);
    force = (agentSize/dist)^lambda;
end
