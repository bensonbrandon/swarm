function [infoA,infoE] = updateArmysSimpCont( agents, loc, W, infoAold,infoEold )


for i = randperm(length(agents))
    agent = agents(i);
    if agent.color == 1
        continue
    end
    posAgent = agent.pos;
    infoA = [0 0];
    infoE = [0 0];
    
    minDist = agent.size;
    minAgent = 0;
    
    for j = 1:length(agents)
        if i ~= j
            other = agents(j);
            posOther = other.pos;
            [infox,infoy,dist] = loc(posAgent,posOther);
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

if agent.color == 1 %red wants to get away from everyone
    forcex = 0;
    forcey = 0;
    %{
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
    %}
else %blue only cares about going towards the red
    forceEx = infoEx-infoAx;
    forceEy = infoEy-infoAy;
    force = (forceEx^2 + forceEy^2)^.5;

    maxf = 1;
    if force > maxf
        outForce = polynomial(W(1:5),maxf);
    else
        outForce = polynomial(W(1:5),force);
    end
    scale = outForce/force;
    forcex = scale*forceEx;
    forcey = scale*forceEy;
    %{
    forceAx = infoAx;
    forceAy = infoAy;
    force = (forceAx^2 + forceAy^2)^.5;

    maxf = 1;
    if force > maxf
        outForce = polynomial(W(6:10),maxf);
    else
        outForce = polynomial(W(6:10),force);
    end
    scale = outForce/force;
    forceAx = scale*forceAx;
    forceAy = scale*forceAy;
    
    forcex = forceEx+forceAx;
    forcey = forceEy+forceAy;
    %}
end
    
end

