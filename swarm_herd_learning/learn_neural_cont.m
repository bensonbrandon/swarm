%clear all
%close all
%select a W to start (comment out W from 'army_assemble_simp_cont')

W2 = [-.5,0,1,0,0,0,0,0,0;0,-.5,0,1,0,0,0,0,0];
W1 = [eye(8),zeros(8,1)];
Wparent1 = W1;
Wparent2 = W2;


for generation = 1:10
    generation
    Wparent1;
    WnextGen1 = zeros([size(Wparent1),5]);
    WnextGen2 = zeros([size(Wparent2),5]);
    Wsteps = zeros(5,1);
%construct next generation
for z = 1:5
    randW1 = [repelem(rand(8,4),1,2),rand(8,1)]; %make it symmetric
    W = {Wparent1+.25*(randW1-.5),Wparent2+.25*(rand(2,9)-.5)};
    army_assemble_neural_cont;
    WnextGen1(:,:,z) = W{1};
    WnextGen2(:,:,z) = W{2};
    if steps == 200
        steps = Inf
    end
    Wsteps(z) = error;
end
for z = 1:5
    WnextGen1(:,:,z) = (Wsteps(z)^-4)*WnextGen1(:,:,z);
    WnextGen2(:,:,z) = (Wsteps(z)^-4)*WnextGen2(:,:,z);
end
Wparent1 = zeros(size(Wparent1));
Wparent2 = zeros(size(Wparent2));
for z = 1:5
    Wparent1 = Wparent1 + WnextGen1(:,:,z);
    Wparent2 = Wparent2 + WnextGen2(:,:,z);
end
Wparent1 = Wparent1/sum(Wsteps.^-4);
Wparent2 = Wparent2/sum(Wsteps.^-4);


end
