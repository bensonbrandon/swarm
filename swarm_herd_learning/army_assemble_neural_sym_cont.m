%this script requires a definition of W and it outputs steps

close all

%N = 50; %number of agents
Np0 = 100;
Np1 = 10;
%control parameters E, then A
%{
W2 = [-.5,0,1,0,0,0,0,0,0;0,-.5,0,1,0,0,0,0,0];
W1 = [eye(8),zeros(8,1)];
W = {W1,W2};
%}
%P = linspace(0,1,100);

agentSize = .02;
shake = .005;
b = .3;
c = agentSize;
lambda = 2; %locality parameter, power of decay (1/r)^lambda

thetap = linspace(0,2*pi,Np0+1)';
thetat = linspace(0,2*pi,Np1+1)';

Px0 = .4.*cos(thetap(1:end-1)) +.5;
Py0 = .4.*sin(thetap(1:end-1))+.5;
%Px1 = .25.*cos(thetat(1:end-1)) +.5;
%Py1 = .25.*sin(thetat(1:end-1))+.5;

loc = @(posA,posO) localityFunction(posA,posO,agentSize,lambda);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   create an array of agents
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
agents = [];
for i = 1:Np0
    agents = [agents ArmyAgent([Px0(i),Py0(i)],[0,0],[b,c,shake,0,agentSize])];
end
for j = 1:Np1
    agents = [agents ArmyAgent([Px1(j),Py1(j)],[0,0],[b,c,0,1,agentSize])];
end
%{
for j = Np0+1:Np0+Np1
    agent = agents(j);
    agent.fix(agent.pos);
end
%}
%figure('units','normalized','position',[.05,.1,.9,.65]);
%subplot(2,2,[1 3])
%set(subplot(2,2,[1 3]),'Color','k')
title('Swarm Simulation')
hold on
h(1) = scatter(Px1,Py1,'r');
h(2) = scatter(Px0,Py0,'hexagram','MarkerFaceColor','b','MarkerEdgeColor','w');
for j = 1:(Np0+Np1)
    g(j) = animatedline('Color','c');
end


percentComplete = 0;
infoAold = [0,0];
infoEold = [0,0];
i = 1;
Error = 0;
while percentComplete<1 && i<201
    i = i + 1
    Error
    
    [infoAold,infoEold,Error] = updateArmysNeuralSymCont(agents,loc,W,infoAold,infoEold);
    
    
    
    [Px0,Py0,Px1,Py1,percentComplete] = army_positions(agents);
    
    
    h(2*i-1) = scatter(Px1,Py1,'r');
    h(2*i) = scatter(Px0,Py0,'hexagram','MarkerFaceColor','b','MarkerEdgeColor','w');
    
    if ishandle(h(2*i-3))
        delete(h(2*i-3));
        delete(h(2*i-2));
    end
    j = 0;
    while j < length(agents)
        j = j+1;
        if j <= Np0
            addpoints(g(j),Px0(j),Py0(j))
        else
            addpoints(g(j),Px1(j-Np0),Py1(j-Np0))
        end
    end
        
    if floor(i/50) == i/50
        drawnow;
    end
    

    xlim([0,1])
    ylim([0,1])
    pause(0)
end

steps = i;