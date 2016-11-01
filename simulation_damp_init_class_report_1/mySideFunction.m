function [force] = mySideFunction(dist,agentSize)
if dist<agentSize
    force = dist/agentSize;
else
    force = (agentSize/dist)^.5;
end
