function [force] = localityFunction(dist,agentSize)
if dist<agentSize
    force = dist/agentSize;
else
    force = (agentSize/dist);
    %force = 1;
end
