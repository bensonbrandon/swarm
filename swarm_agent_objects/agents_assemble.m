clear all
close all


N = 50; %number of agents
P = linspace(0.01,1,100);
%P = (N*P).^-1;

agentSize = .02;
shake = .005;
b = .2;
c = agentSize;
lambda = 1; %locality parameter, power of decay (1/r)^lambda
circleAgents = 0;
ra = 0.45;
circleTargets = 1;
rt = .20;


theta = linspace(0,2*pi,N+1)';

if circleAgents
    Px = ra.*cos(theta(1:end-1)) +.5;
    Py = ra.*sin(theta(1:end-1))+.5;
else
    [Px,Py] = randomPositions(N,agentSize);
end

if circleTargets>0
    Tx = rt.*cos(theta(1:end-1)) +.5;
    Ty = rt.*sin(theta(1:end-1))+.5;
else
    [Tx,Ty] = randomPositions(N,agentSize);
end
loc = @(posA,posO) localityFunction(posA,posO,agentSize,lambda);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   create an array of agents
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
agents = [];
for i = 1:N
    agents = [agents Agent([Px(i),Py(i)],[0,0],P,[b,c,shake,0,agentSize])];
end
for j = 1:N
    agents = [agents Agent([Tx(j),Ty(j)],[0,0],P,[b,c,shake,1,agentSize])];
end
 
Px = [Px;Tx];
Py = [Py;Ty];

figure('units','normalized','position',[.05,.1,.9,.65]);
subplot(2,2,[1 3])
set(subplot(2,2,[1 3]),'Color','k')
title('Swarm Simulation')
hold on
h(1) = scatter(Px(end/2 +1:end),Py(end/2 +1:end),'r');
h(2) = scatter(Px(1:end/2),Py(1:end/2),'hexagram','MarkerFaceColor','b','MarkerEdgeColor','w');
for j = 1:length(Px)
    g(j) = animatedline('Color','c');
end
subplot(2,2,2)
title('Percent Complete')
xlabel('Time Steps')
ylabel('Percent of Targets Found')
set(subplot(2,2,2),'Color','w')
m = animatedline('Color','k');

subplot(2,2,4)

d = 0:.001:1;
locF = zeros(1,length(d));
df = agentSize:.001:1;
contlocF = zeros(1,length(df));
for i = 1:length(locF)
    locF(i) = loc([0 0],[d(i) 0]);
end
for i = 1:length(contlocF)
    contlocF(i) = loc([0 0],[df(i) 0]);
end

contF = interp1(linspace(0,1,length(P)),P,contlocF);
hold on
plot(d,locF,'b')
plot(df,contF,'r')
legend('locality function','control function')
title('Locality and Control Functions')
xlabel('distance')
ylabel('amplitude')
%}
%takenAgentsTargets = zeros(length(Tx),2);
percentComplete = [0];
i = 1;
while percentComplete < 1
    i = i + 1;

    [Px,Py, percentComp] = updateAgents(agents,loc);
    percentComplete = [percentComplete; percentComp];
    subplot(2,2,2)
    addpoints(m,i,percentComplete(i));


    subplot(2,2,[1 3])
    h(2*i-1) = scatter(Px(end/2 +1:end),Py(end/2 +1:end),'r');
    h(2*i) = scatter(Px(1:end/2),Py(1:end/2),'hexagram','MarkerFaceColor','b','MarkerEdgeColor','w');
    if ishandle(h(2*i-3))
        delete(h(2*i-3));
        delete(h(2*i-2));
    end
    for j = 1:length(Px)
        addpoints(g(j),Px(j),Py(j))
    end
    %drawnow;
    
    if floor(i/50) == i/50
        drawnow;
    end
    

    xlim([0,1])
    ylim([0,1])
    pause(0)
end
