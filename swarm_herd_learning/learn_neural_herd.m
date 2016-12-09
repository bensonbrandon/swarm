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
%load('Wparent_neur_sym_cont_after170')
%Wparent1 = [Wparent1,zeros(8,2)];

%Wparent1 = [[Wparent1,zeros(8,2)];zeros(2,11)];
%Wparent2 = [Wparent2,zeros(2,2)];
%load('Wparent_neur_herd_afterCam')

load('Wparent_neur_herd2_after300.mat')
%Wparent1 = zeros(10,11);
%Wparent2 = zeros(2,11);
%load('Wparent_neur_herd_100r')

for generation = 1:1
    
    Wparent1;
    WnextGen1 = zeros([size(Wparent1),5]);
    WnextGen2 = zeros([size(Wparent2),5]);
    Wsteps = zeros(5,1);
%construct next generation
mom = 0;
momError = Inf;
dad = 0;
dadError = Inf;
for z = 1:1
    %randW1 = [repelem(rand(8,4),1,2),rand(8,1)]; %make it symmetric
    generation
    %W = {Wparent1+.1*(rand(10,11)-.5),Wparent2+.1*(rand(2,11)-.5)};
    W = {Wparent1,Wparent2};
    army_assemble_neural_herd;
    WnextGen1(:,:,z) = W{1};
    WnextGen2(:,:,z) = W{2};
    
    Wsteps(z) = steps/percentComplete; 
    %Wsteps(z) = steps*Error; %started with this one for training
    Error = steps/percentComplete;
    %Error = steps*Error;
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
