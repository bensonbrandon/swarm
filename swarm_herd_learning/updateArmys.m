function [ Px,Py,percentComplete ] = updateArmys( agents, loc )
%Update performs a step of all the agents based on the environment
%if agents are within a .1x.1 square, then there is a chance that some will
%die proportional to the number of agents in that square

for i = randperm(length(agents))
    agent = agents(i);
    posAgent = agent.pos;
    infoA = [0 0];
    infoE = [0 0];
        
    for j = 1:length(agents)
        if i ~= j
            other = agents(j);
            posOther = other.pos;
            [infox,infoy,~] = loc(posAgent,posOther);
            if agent.color == other.color
                infoA = [infoA(1) + infox,infoA(2) + infoy];
            else
                infoE = [infoE(1) + infox,infoE(2) + infoy];
            end
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   convert info to force 
%   (maps interval (0,1) in info to (0,1) in force)
infoAx = infoA(1);
infoAy = infoA(2);
infoEx = infoE(1);
infoEy = infoE(2);

forcex = infoEx - infoAx;
sgn = sign(forcex);
forcex = abs(forcex);
maxf = 1;
if forcex > maxf
    forcex = agent.contParaUpdate{2}(end);
else
    forcex = interp1(linspace(0,maxf,length(agent.contParaUpdate{2})),agent.contParaUpdate{2},forcex);
end
forcex = sgn*forcex;

forcey = infoEy - infoAy;
sgn = sign(forcey);
forcey = abs(forcey);
maxf = 1;
if forcey > maxf
    forcey = agent.contParaUpdate{2}(end);
else
    forcey = interp1(linspace(0,maxf,length(agent.contParaUpdate{2})),agent.contParaUpdate{2},forcey);
end
forcey = sgn*forcey;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

agent.step(forcex,forcey);
end
    
percentComplete = 0;

Px = zeros(length(agents),1);
Py = zeros(length(agents),1);
for k = 1:length(agents)
    agent = agents(k);
    Px(k) = agent.pos(1);
    Py(k) = agent.pos(2);
end
end

