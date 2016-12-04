function [infoA,infoE,totalDist] = updateArmysNeuralCont( agents, loc, W, infoAold,infoEold )

totalDist = 0;
for i = randperm(length(agents))
    agent = agents(i);
    if agent.color == 1 || agent.fixed
        continue
    end
    posAgent = agent.pos;
    infoA = [0 0];
    infoE = [0 0];
    
    minDist = Inf;
    minAgent = 0;
    
    for j = randperm(length(agents))
        if i ~= j && agents(j).fixed==0 %require that this agent
            %isn't the same as the other and is not fixed
            other = agents(j);
            posOther = other.pos;
            [infox,infoy,dist] = loc(posAgent,posOther);
            if ~(dist<Inf)
                'yo'
            end
            if dist==0
                'yell'
            end
            if agent.color == other.color
                infoA = [infoA(1) + infox,infoA(2) + infoy];
            else
                infoE = [infoE(1) + infox,infoE(2) + infoy];
                if dist<minDist
                    minDist = dist;
                    minAgent = j;
                end
            end
            
        end
    end
    if minDist<agent.size && agent.fixed==0
        other = agents(minAgent);
        if other.fixed==0
            agent.fix(other.pos);
            other.fix(other.pos);
        end
    end
    totalDist = totalDist + minDist;
    [forcex,forcey] = control(agent,infoA,infoE,infoAold,infoEold, W);

    agent.step(forcex,forcey);
end

end

function [forcex,forcey] = control(agent,infoA,infoE,infoAold,infoEold,W)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   convert info to force 
%   (maps interval (0,1) in info to (0,1) in force)
infoAx = infoA(1);
infoAy = infoA(2);
infoEx = infoE(1);
infoEy = infoE(2);
infodAx = infoAx - infoAold(1);
infodAy = infoAy - infoAold(2);
infodEx = infoEx - infoEold(1);
infodEy = infoEy - infoEold(2);

X = [infoAx;infoAy;infoEx;infoEy;infodAx;infodAy;infodEx;infodEy];

if agent.color == 1 %red stays fixed
    forcex = 0;
    forcey = 0;
    
else %blue
    X = [X;1];
    Y = W{2}*[tanh(W{1}*X);1];
    forcex = Y(1);
    forcey = Y(2);
end
    
end

