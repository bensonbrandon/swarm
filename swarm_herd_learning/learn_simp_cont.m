clear all
close all
%select a W to start (comment out W from 'army_assemble_simp_cont')
Wparent = [1,-1,0,0,0];

for generation = 1:15
    generation
    Wparent
WnextGen = zeros(5,length(Wparent));
Wsteps = zeros(5,1);
%construct next generation
for z = 1:5
    W = Wparent + rand(1,length(Wparent))-.5;
    army_assemble_simp_cont;
    WnextGen(z,:) = W;
    if steps == 100
        steps = Inf
    end
    Wsteps(z) = steps;
end
for z = 1:5
    WnextGen(z,:) = (Wsteps(z)^-2)*WnextGen(z,:);
end
for z = 1:length(Wparent)
    Wparent(z) = sum(WnextGen(:,z))/sum((Wsteps.^-2));
end


end
