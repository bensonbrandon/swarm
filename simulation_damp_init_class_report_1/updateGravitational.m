function [ Xnew, Ynew, Vxnew,Vynew,objFunc, takenAgentsTargets ] = updateGravitational( Px,Py,Vx,Vy,Tx,Ty,b,localityFunction,agentSize,takenAgentsTargets )
%X,Y are the current positions of agents
%Tx,Ty are the positions of the targets
%this function uses a graviational potential as an objective function
%where all agents repel each other and targets attract them
%metropolis monte carlo is used to minimize the objective function

%shake = agentSize/10;
shake = .005;
threshSpeed = agentSize;
c = agentSize; %step size
%c = b;
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
    forcex = 0;
    forcey = 0;
    closestTarget = [0,Inf]; %index and distance of the closest target used 
                             %to resolve conflicts between multiple targets 
                             %that are close enough to claim a single agent
    for j = 1:length(Tx)
        if takenAgentsTargets(j,2) %if target is taken dont consider it
            continue
        end
        [forcexj,forceyj,dist] = getForceComp(x,y,Tx(j),Ty(j),localityFunction,agentSize);
        if (dist < minDistances(j)) 
            minDistances(j) = dist; 
        end
        if (dist < agentSize) && takenAgentsTargets(j,2)==0 && dist<closestTarget(2)
            closestTarget(1) = j;
            closestTarget(2) = dist;
        end
            
        forcex = forcex + forcexj;
        forcey = forcey + forceyj;
    end
    
    if closestTarget(1) ~= 0 %if there is a closest target, enforce exclusion principle
        takenAgentsTargets(closestTarget(1),2) = 1;
        takenAgentsTargets(i,1) = 1;
        Xnew(i) = Tx(closestTarget(1));
        Ynew(i) = Ty(closestTarget(1));
        continue
    end
    
    for k = 1:length(Xnew)
        if k == i || takenAgentsTargets(k,1) == 1
            continue
        end
        [forcexk,forceyk] = getForceComp(x,y,Xnew(k),Ynew(k),localityFunction,agentSize);
        forcex = forcex - forcexk;
        forcey = forcey - forceyk;
    end
    
    if takenAgentsTargets(i,1) == 1
        continue
    end
    %{
    if (c*(forcex^2 + forcey^2)^.5 > threshSpeed)
        forcex = forcex*(threshSpeed/c) / (forcex^2 + forcey^2)^.5;
        forcey = forcey*(threshSpeed/c) / (forcex^2 + forcey^2)^.5;
    end
    %}
    Xnew(i) = 1/(b+1) *(c*forcex) + x + (1/(b+1))*Vx(i) + shake*(rand-.5);
    %Vxnew(i) + shake*(rand-.5);
    Ynew(i) = 1/(b+1) *(c*forcey) + y + (1/(b+1))*Vy(i) + shake*(rand-.5);
    Vxnew(i) = Xnew(i) - x;
    Vynew(i) = Ynew(i) - y;
    %Vx(i) + c*forcex - 1*Vx(i);
    %Vynew(i) = Vy(i) + c*forcey - 1*Vy(i);
    
end
objFunc = sum(minDistances);
end



function [forceCompX,forceCompY,Dist] = getForceComp(x,y,qx,qy,localityFunction,agentSize)
%takes one dimension of the positions and one dimension of the positions in
%question, then computes the component of the graviational force in that
%direction
Dist = ((qx-x)^2 + (qy-y)^2)^.5;
forceCompX = ((qx-x)/Dist)*localityFunction(Dist,agentSize);
forceCompY = ((qy-y)/Dist)*localityFunction(Dist,agentSize);
end
