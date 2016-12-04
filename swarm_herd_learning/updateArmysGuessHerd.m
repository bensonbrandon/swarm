function [] = updateArmysGuessHerd( agents, loc, P )
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
[forcex,forcey] = control(agent,infoA,infoE,P);

agent.step(forcex,forcey);
end
end

function [forcex,forcey] = control(agent,infoA,infoE,P)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   convert info to force 
%   (maps interval (0,1) in info to (0,1) in force)
infoAx = infoA(1);
infoAy = infoA(2);
infoEx = infoE(1);
infoEy = infoE(2);

if agent.color == 1 %red wants to get away from everyone
    forcex = -infoEx - infoAx;
    forcey = -infoEy - infoAy;
    force = (forcex^2 + forcey^2)^.5;
    maxf = 1;
    if force > maxf
        outForce = maxf;
    else
        outForce = force;
    end
    scale = outForce/force;
    forcex = scale*forcex;
    forcey = scale*forcey;
else %blue only cares about going towards the red
    forcex = (infoEx-.05*infoAx) - .001;
    forcey = (infoEy-.05*infoAy) - .001;
    force = (forcex^2 + forcey^2)^.5;

    maxf = 1;
    if force > maxf
        outForce = -9*maxf;
    else
        outForce = maxf-10*force;
    end
    scale = outForce/force;
    forcex = scale*forcex;
    forcey = scale*forcey;
end
    
end

