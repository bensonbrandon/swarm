function [Px0,Py0,Px1,Py1] = army_positions(agents)
Px0 = [];
Py0 = [];
Px1 = [];
Py1 = [];
u = 1;
p0i = 1;
p1i = 1;
while u<=length(agents)
    agent = agents(u);
    if agent.color == 0
        Px0 = [Px0;agent.pos(1)];
        Py0 = [Py0;agent.pos(2)];
        p0i = p0i + 1;
        u = u+1;
    else
        Px1 = [Px1;agent.pos(1)];
        Py1 = [Py1;agent.pos(2)];
        p1i = p1i + 1;
        u = u+1;
    end
end

end