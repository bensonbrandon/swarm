function [infox,infoy,dist] = localityFunction(posA,posO,agentSize,lambda)
dist = ((posO(1)-posA(1))^2 + (posO(2)-posA(2))^2)^.5;
if dist<agentSize
    info = dist/agentSize;
else
    info = (agentSize/dist)^lambda;
end
infox = info*(posO(1)-posA(1))/dist;
infoy = info*(posO(2)-posA(2))/dist;
end
