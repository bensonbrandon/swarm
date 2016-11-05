function [ xnew,ynew,vxnew,vynew,Pnew ] = agentController( x,y,vx,vy,forceTx,forceTy,forceAx,forceAy,P,c,b,shake )
%agentController given an input force, agent decides which force to feel
%   Detailed explanation goes here
%force = forceT-forceA;
forcex = forceTx- forceAx;
sgnf = sign(forcex);
forcex = abs(forcex);
maxf = 1;
if forcex > maxf
    forcex = P(end);
else
    forcex = interp1(linspace(0,maxf,length(P)),P,forcex);
end

forcex = sgnf*forcex;


forcey = forceTx- forceAx;
sgnf = sign(forcey);
forcey = abs(forcey);
maxf = 1;
if forcey > maxf
    forcey = P(end);
else
    forcey = interp1(linspace(0,maxf,length(P)),P,forcey);
end

forcey = sgnf*forcey;

xnew = 1/(b+1) *c*forcex + x + (1/(b+1))*vx + shake*(rand-.5);
ynew = 1/(b+1) *c*forcey + y + (1/(b+1))*vy + shake*(rand-.5);
vxnew = xnew - x;
vynew = ynew - y;

Pnew = P;

end

