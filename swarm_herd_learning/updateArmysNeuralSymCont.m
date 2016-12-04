function [infoA,infoE,totalDist] = updateArmysNeuralSymCont( agents, loc, W, infoAold,infoEold )

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
        %if i ~= j
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
    if isnan(agent.pos)
        'blah'
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
    if isnan(agent.pos)
        'blah'
    end
    agent.step(forcex,forcey);
    if isnan(agent.pos)
        'blah'
    end
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

infoAm = (infoAx^2 + infoAy^2)^.5;
infoEm = (infoEx^2 + infoEy^2)^.5;
Axn = infoAx/infoAm;
Ayn = infoAy/infoAm;
Exn = infoEx/infoEm;
Eyn = infoEy/infoEm;
infoTae = wrapToPi(atan2(Ayn,Axn)-atan2(Eyn,Exn));

infodAm = (infodAx^2 + infodAy^2)^.5;
infodEm = (infodEx^2 + infodEy^2)^.5;
dAxn = infodAx/infodAm;
dAyn = infodAy/infodAm;
dExn = infodEx/infodEm;
dEyn = infodEy/infodEm;
infodTae = wrapToPi(atan2(dAyn,dAxn)-atan2(dEyn,dExn));
if infoAm==0 || infoEm==0
    infoTae = 0;
end
if infodAm==0 || infodEm==0
    infodTae = 0;
end

%X = [infoAx;infoAy;infoEx;infoEy;infodAx;infodAy;infodEx;infodEy];
X = [infoAm,infoEm,infoTae,infodAm,infodEm,infodTae]';

if agent.color == 1 %red stays fixed
    forcex = 0;
    forcey = 0;
    
else %blue
    X = [X;1];
    Y = tanh(W{2}*[tanh(W{1}*X);1]);
    Fm = Y(1);
    Tfe = pi*Y(2);
    forcex = -Fm*cos(Tfe)*Eyn + Fm*sin(Tfe)*Exn;
    forcey = Fm*cos(Tfe)*Exn + Fm*sin(Tfe)*Eyn;
end
if isnan(forcex)||isnan(forcey)
    'blah'
end

end

