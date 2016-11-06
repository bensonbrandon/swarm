function [ Px,Py,percentComplete ] = updateAgents( agents, loc )
%Update performs a step of all the agents based on the environment

for i = 1:length(agents)
    agent = agents(i);
    posAgent = agent.pos;
    infoA = [0 0];
    infoE = [0 0];
    
    for j = 1:length(agents)
        if i ~= j
            other = agents(j);
            posOther = other.pos;
            [infox,infoy,dist] = loc(posAgent,posOther);
            if agent.color == other.color
                infoA = [infoA(1) + infox,infoA(2) + infoy];
            else
                infoE = [infoE(1) + infox,infoE(2) + infoy];
                if dist<agent.size && agent.fixed==0 && other.fixed==0
                    agent.fix(agent.pos)
                    other.fix(agent.pos)
                end
            end
            
        end
    end
agent.step(infoA,infoE);
end
    
percentComplete = 0;
for l = 1:length(agents)
    agent = agents(l);
    if agent.fixed
        percentComplete = percentComplete + 1;
    end
end
percentComplete = percentComplete/length(agents);

Px = zeros(length(agents),1);
Py = zeros(length(agents),1);
for k = 1:length(agents)
    agent = agents(k);
    Px(k) = agent.pos(1);
    Py(k) = agent.pos(2);
end

end

