function [infoA,infoE,infoR,totalDist] = updateArmysNeuralHerd( agents, loc, W, infoAold,infoEold,infoRold )

totalDist = 0;


for i = randperm(length(agents))
    agent = agents(i);
    
    if agent.color == 2 || agent.fixed%reference 
        continue
    end
    
    posAgent = agent.pos;
    infoA = [0 0];
    infoE = [0 0];
    infoR = [0 0];
        
    for j = randperm(length(agents))
        other = agents(j);
        if i == j || other.fixed %require that this agent
            continue
        end
        
        %isn't the same as the other and is not fixed

        posOther = other.pos;
        [infox,infoy,dist] = loc(posAgent,posOther);
        %{
        if ~(dist<Inf)
            'yo'
        end
        if dist==0
            'yell'
        end
        %}
        if agent.color == other.color && other.color~=2
            infoA = [infoA(1) + infox,infoA(2) + infoy];
        elseif agent.color ~= other.color && other.color~=2
            infoE = [infoE(1) + infox,infoE(2) + infoy];
        else
            infoR = [infoR(1) + infox,infoR(2) + infoy];
        end
    end
    if isnan(agent.pos)
        'blah'
    end
    
    if ~agent.fixed
        
        [forcex,forcey] = control(agent,infoA,infoE,infoR,infoAold,infoEold,infoRold, W);

        if agent.color == 1 && .1>((agent.pos(1)-.5)^2+(agent.pos(2)-.5)^2)^.5
            agent.fix([.5 .5])
        end
        agent.step(forcex,forcey);
    end
   
end
end

function [forcex,forcey] = control(agent,infoA,infoE,infoR,infoAold,infoEold,infoRold,W)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   convert info to force 
%   (maps interval (0,1) in info to (0,1) in force)
infoAx = infoA(1);
infoAy = infoA(2);
infoEx = infoE(1);
infoEy = infoE(2);
infoRx = infoR(1);
infoRy = infoR(2);
infodAx = infoAx - infoAold(1);
infodAy = infoAy - infoAold(2);
infodEx = infoEx - infoEold(1);
infodEy = infoEy - infoEold(2);
infodRx = infoRx - infoRold(1);
infodRy = infoRy - infoRold(2);

infoAm = (infoAx^2 + infoAy^2)^.5;
infoEm = (infoEx^2 + infoEy^2)^.5;
infoRm = (infoRx^2 + infoEy^2)^.5;
Axn = infoAx/infoAm;
Ayn = infoAy/infoAm;
Exn = infoEx/infoEm;
Eyn = infoEy/infoEm;
Rxn = infoRx/infoRm;
Ryn = infoRy/infoRm;
infoTae = wrapToPi(atan2(Ayn,Axn)-atan2(Eyn,Exn));

infodAm = (infodAx^2 + infodAy^2)^.5;
infodEm = (infodEx^2 + infodEy^2)^.5;
infodRm = (infodRx^2 + infodRy^2)^.5;
dAxn = infodAx/infodAm;
dAyn = infodAy/infodAm;
dExn = infodEx/infodEm;
dEyn = infodEy/infodEm;
dRxn = infodRx/infodRm;
dRyn = infodRy/infodRm;
infodTae = wrapToPi(atan2(dAyn,dAxn)-atan2(dEyn,dExn));
if infoAm==0 || infoEm==0
    infoTae = 0;
end
if infodAm==0 || infodEm==0
    infodTae = 0;
end

infoTer = wrapToPi(atan2(Ryn,Rxn)-atan2(Eyn,Exn));
infodTer = wrapToPi(atan2(dRyn,dRxn)-atan2(dEyn,dExn));

%X = [infoAx;infoAy;infoEx;infoEy;infodAx;infodAy;infodEx;infodEy];
X = [infoAm,infoEm,infoTae,infodAm,infodEm,infodTae,infoRm,infodRm,infoTer,infodTer]';

if agent.color == 1 %red stays fixed
    forcex = .1*(-infoAx-infoEx);
    forcey = .1*(-infoAy-infoEy);
    
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

