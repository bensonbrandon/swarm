%clear all
%close all
%select a W to start (comment out W from 'army_assemble_simp_cont')

%W2 = [-.5,0,1,0,0,0,0,0,0;0,-.5,0,1,0,0,0,0,0];
%{
W2 = zeros(2,9);
W1 = [[eye(6),zeros(6,1)];zeros(2,7)];
Wparent1 = W1;
Wparent2 = W2;
%}

%load('Wparent_neur_sym_cont_after20.mat')
%load('good_one2')
%Wparent1 = W{1};
%Wparent2 = W{2};
load('Wparent_neur_sym_cont_after170')

for generation = 1:30
    
    Wparent1;
    WnextGen1 = zeros([size(Wparent1),5]);
    WnextGen2 = zeros([size(Wparent2),5]);
    Wsteps = zeros(5,1);
%construct next generation
mom = 0;
momError = Inf;
dad = 0;
dadError = Inf;
for z = 1:5
    %randW1 = [repelem(rand(8,4),1,2),rand(8,1)]; %make it symmetric
    generation
    W = {Wparent1+.05*(rand(8,7)-.5),Wparent2+.05*(rand(2,9)-.5)};
    army_assemble_neural_sym_cont;
    WnextGen1(:,:,z) = W{1};
    WnextGen2(:,:,z) = W{2};
    
    %Wsteps(z) = steps/percentComplete;
    Wsteps(z) = steps;
    %Error = steps/percentComplete;
    Error = steps;
    if Error<dadError
        dad = z;
        mom = dad;
        dadError = Error;
        momError = dadError;
    elseif Error<momError
        mom = z;
        momError = Error;
    end
end
W1dad = (dadError^-2)*WnextGen1(:,:,dad);
W1mom = (momError^-2)*WnextGen1(:,:,mom);
W2dad = (dadError^-2)*WnextGen2(:,:,dad);
W2mom = (momError^-2)*WnextGen2(:,:,mom);

Wparent1 = (W1dad+W1mom)/(dadError^-2 + momError^-2);
Wparent2 = (W2dad+W2mom)/(dadError^-2 + momError^-2);

end
