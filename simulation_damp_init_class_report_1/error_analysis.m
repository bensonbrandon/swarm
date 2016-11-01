iterations = 10;

N = 100; %number of agents
agentSize = .02;
b = .8;
circleAgents = 0;
ra = .50;
circleTargets = 0;
rt = .25;

n100_bp8_r_r = [];
for i = 1:iterations
    agents_assemble
    n100_bp8_r_r = [n100_bp8_r_r; percentComplete];
end

circleAgents = 0;
circleTargets = 1;

n100_bp8_r_c = [];
for i = 1:iterations
    agents_assemble
    n100_bp8_r_c = [n100_bp8_r_c; percentComplete];
end

circleAgents = 1;
circleTargets = 0;

n100_bp8_c_r = [];
for i = 1:iterations
    agents_assemble
    n100_bp8_c_r = [n100_bp8_c_r; percentComplete];
end

circleAgents = 1;
circleTargets = 1;

n100_bp8_c_c = [];
for i = 1:iterations
    agents_assemble
    n100_bp8_c_c = [n100_bp8_c_c; percentComplete];
end

save('n100_bp8_run1.mat','n100_bp8_r_r','n100_bp8_r_c','n100_bp8_c_r','n100_bp8_c_c');