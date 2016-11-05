clear all
close all
%hi
P = linspace(0,1,100);
P = P.^.5;
 
%P = ones(1,100);
N = 100; %number of agents
Pall = zeros(N,length(P));
for i = 1:N
    Pall(i,:) = P;
end
P = Pall;
agentSize = .02;
df = agentSize;
b = .2;
c = agentSize;
lambda = 1; %locality parameter, power of decay (1/r)^lambda
circleAgents = 0;
ra = 0.45;
circleTargets = 1;
rt = .20;


theta = linspace(0,2*pi,N+1);

if circleAgents
    Px = ra.*cos(theta(1:end-1)) +.5;
    Py = ra.*sin(theta(1:end-1))+.5;
    Vx = zeros(N,1);
    Vy = zeros(N,1);
else
    [Px,Py] = randomPositions(N,agentSize);
    Vx = zeros(N,1);
    Vy = zeros(N,1);
end

if circleTargets>0
    Tx = rt.*cos(theta(1:end-1)) +.5;
    Ty = rt.*sin(theta(1:end-1))+.5;
else
    [Tx,Ty] = randomPositions(N,agentSize);
end

forceFunction = @(x) localityFunction(x,agentSize,lambda);
controlFunction = @(ft,fa,P) agentController(ft,fa,P);

figure('units','normalized','position',[.05,.1,.9,.65]);
subplot(2,2,[1 3])
set(subplot(2,2,[1 3]),'Color','k')
title('Swarm Simulation')
hold on
scatter(Tx,Ty,'r')
h(1) = scatter(Px,Py,'hexagram','MarkerFaceColor','b','MarkerEdgeColor','w');
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
contF = zeros(1,length(df));
for i = 1:length(locF)
    locF(i) = forceFunction(d(i));
end
for j = 1:length(contF)
    contF(j) = controlFunction(forceFunction(df(j)),0,P(1,:));
end
hold on
plot(d,locF,'b')
plot(df,contF,'r')
legend('locality function','control function')
title('Locality and Control Functions')
xlabel('distance')
ylabel('amplitude')

takenAgentsTargets = zeros(length(Tx),2);
percentComplete = [0];
i = 1;
while percentComplete < 1
    i = i + 1;

    [Px,Py,Vx,Vy,P,~,takenAgentsTargets] = updateGravitational(Px,Py,Vx,Vy,P,Tx,Ty,b,c,forceFunction,controlFunction,agentSize,takenAgentsTargets);
    percentComplete = [percentComplete; sum(takenAgentsTargets(:,2))/N];
    subplot(2,2,2)
    addpoints(m,i,percentComplete(i));


    subplot(2,2,[1 3])
    h(i) = scatter(Px,Py,'hexagram','MarkerFaceColor','b','MarkerEdgeColor','w');
    if ishandle(h(i-1))
        delete(h(i-1));
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
