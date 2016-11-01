function [ out ] = agentController( forceT,forceA,P,i )
%agentController given an input force, agent decides which force to feel
%   Detailed explanation goes here
%force = forceT-forceA;
force = forceT- forceA;
sgnf = sign(force);
force = abs(force);
maxf = 1;
if force > maxf
    force = P(i,end);
else
    force = interp1(linspace(0,maxf,length(P(i,:))),P(i,:),force);
end

out = sgnf*force;
end

