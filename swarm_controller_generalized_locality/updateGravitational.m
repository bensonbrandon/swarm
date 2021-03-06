function [ Xnew, Ynew, Vxnew,Vynew,objFunc, takenAgentsTargets ] = updateGravitational( Px,Py,Vx,Vy,Tx,Ty,b,c,forceF,controlF,agentSize,takenAgentsTargets )
%X,Y are the current positions of agents
%Tx,Ty are the positions of the targets
%this function uses a graviational potential as an objective function
%where all agents repel each other and targets attract them
%metropolis monte carlo is used to minimize the objective function

%shake = agentSize/10;
shake = .005;
Xnew = Px;
Ynew = Py;
Vxnew = Vx;
Vynew = Vy;
minDistances = Inf*ones(1,length(Tx)); %minimum distance from any agent to the targets
for a = 1:length(takenAgentsTargets(:,2))
    if takenAgentsTargets(a,2) == 1
        minDistances(a) = 0;
    end
end

for i = randperm(length(Xnew))
    if takenAgentsTargets(i,1) == 1 %if this agent is taken, don't update it
        continue
    end
    x = Xnew(i);
    y = Ynew(i);
    forceTx = 0;
    forceTy = 0;
    closestTarget = [0,Inf]; %index and distance of the closest target used 
                             %to resolve conflicts between multiple targets 
                             %that are close enough to claim a single agent
    for j = 1:length(Tx)
        if takenAgentsTargets(j,2) %if target is taken dont consider it
            continue
        end
        [forcexj,forceyj,dist] = getForceComp(x,y,Tx(j),Ty(j),forceF);
        if (dist < minDistances(j)) 
            minDistances(j) = dist; 
        end
        if (dist < agentSize) && takenAgentsTargets(j,2)==0 && dist<closestTarget(2)
            closestTarget(1) = j;
            closestTarget(2) = dist;
        end
            
        forceTx = forceTx + forcexj;
        forceTy = forceTy + forceyj;
    end
%yozen, 4036.  
    if closestTarget(1) ~= 0 %if there is a closest target, enforce exclusion principle
        takenAgentsTargets(closestTarget(1),2) = 1;
        takenAgentsTargets(i,1) = 1;
        Xnew(i) = Tx(closestTarget(1));
        Ynew(i) = Ty(closestTarget(1));
        continue
    end
    
    forceAx = 0;
    forceAy = 0;
    for k = 1:length(Xnew)
        if k == i || takenAgentsTargets(k,1) == 1
            continue
        end
        [forcexk,forceyk] = getForceComp(x,y,Xnew(k),Ynew(k),forceF);
        forceAx = forceAx + forcexk;
        forceAy = forceAy + forceyk;
    end
    
    if takenAgentsTargets(i,1) == 1
        continue
    end
    
    Xnew(i) = 1/(b+1) *c*controlF(forceTx,forceAx,i) + x + (1/(b+1))*Vx(i) + shake*(rand-.5);
    Ynew(i) = 1/(b+1) *c*controlF(forceTy,forceAy,i) + y + (1/(b+1))*Vy(i) + shake*(rand-.5);
    Vxnew(i) = Xnew(i) - x;
    Vynew(i) = Ynew(i) - y;
    
end
objFunc = sum(minDistances);
end



function [forceCompX,forceCompY,Dist] = getForceComp(x,y,qx,qy,forceFunction)
%takes one dimension of the positions and one dimension of the positions in
%question, then computes the component of the graviational force in that
%direction
Dist = ((qx-x)^2 + (qy-y)^2)^.5;
forceCompX = ((qx-x)/Dist)*forceFunction(Dist);
forceCompY = ((qy-y)/Dist)*forceFunction(Dist);
end
