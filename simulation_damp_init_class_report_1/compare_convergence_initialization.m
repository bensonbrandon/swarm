load('n100_bp1_run1.mat')
rr = n100_bp1_r_r;
rc = n100_bp1_r_c;
cr = n100_bp1_c_r;
cc = n100_bp1_c_c;

%find the indicies when each simulation starts: i,j,k,l
%find the convergence time of each sim: iLength,jLength,kLength,lLength

i = zeros(11,1);
index = 0;
arrayExt = [-1;rr;0];
for val = 2:length(arrayExt)
    if arrayExt(val-1)~=0 && arrayExt(val)==0
        index = index + 1;
        i(index) = val-1;
    end
end
iLength = diff(i);
j = zeros(11,1);
index = 0;
arrayExt = [-1;rc;0];
for val = 2:length(arrayExt)
    if arrayExt(val-1)~=0 && arrayExt(val)==0
        index = index + 1;
        j(index) = val-1;
    end
end
jLength = diff(j);
k = zeros(11,1);
index = 0;
arrayExt = [-1;cr;0];
for val = 2:length(arrayExt)
    if arrayExt(val-1)~=0 && arrayExt(val)==0
        index = index + 1;
        k(index) = val-1;
    end
end
kLength = diff(k);
l = zeros(11,1);
index = 0;
arrayExt = [-1;cc;0];
for val = 2:length(arrayExt)
    if arrayExt(val-1)~=0 && arrayExt(val)==0
        index = index + 1;
        l(index) = val-1;
    end
end
lLength = diff(l);

    
%{  
i = find([rr;0] == 0); %get the restart points from zeros
iLength = diff(i);
iLength(find(iLength==1)) = []; %remove any of the repeat zeros
j = find([rc;0] == 0);
jLength = diff(j);
jLength(find(jLength==1)) = [];
k = find([cr;0] == 0);
kLength = diff(k);
kLength(find(kLength==1)) = [];
l = find([cc;0] == 0);
lLength = diff(l);
lLength(find(lLength==1)) = [];
%}
%average and std of convergence times
iMS = [mean(iLength),std(iLength)];
jMS = [mean(jLength),std(jLength)];
kMS = [mean(kLength),std(kLength)];
lMS = [mean(lLength),std(lLength)];


maxLen = max([iLength;jLength;kLength;lLength]);

convergeI = zeros(10,maxLen);
convergeJ = zeros(10,maxLen);
convergeK = zeros(10,maxLen);
convergeL = zeros(10,maxLen);


index = 1;
for a = 1:10
    vec = rr(index:index+iLength(a)-1);
    index = index + iLength(a);
    convergeI(a,:) = [vec' ones(1,maxLen-length(vec))];
end

rrFinal = zeros(2,maxLen);
for b = 1:maxLen
    rrFinal(1,b) = mean(convergeI(:,b));
    rrFinal(2,b) = std(convergeI(:,b));
end

index = 1;
for a = 1:10
    vec = rc(index:index+jLength(a)-1);
    index = index + jLength(a);
    convergeJ(a,:) = [vec' ones(1,maxLen-length(vec))];
end

rcFinal = zeros(2,maxLen);
for b = 1:maxLen
    rcFinal(1,b) = mean(convergeJ(:,b));
    rcFinal(2,b) = std(convergeJ(:,b));
end


index = 1;
for a = 1:10
    vec = cr(index:index+kLength(a)-1);
    index = index + kLength(a);
    convergeK(a,:) = [vec' ones(1,maxLen-length(vec))];
end

crFinal = zeros(2,maxLen);
for b = 1:maxLen
    crFinal(1,b) = mean(convergeK(:,b));
    crFinal(2,b) = std(convergeK(:,b));
end


index = 1;
for a = 1:10
    vec = cc(index:index+lLength(a)-1);
    index = index + lLength(a);
    convergeL(a,:) = [vec' ones(1,maxLen-length(vec))];
end

ccFinal = zeros(2,maxLen);
for b = 1:maxLen
    ccFinal(1,b) = mean(convergeL(:,b));
    ccFinal(2,b) = std(convergeL(:,b));
end
semilogx(100*rrFinal(1,:),'r','LineWidth',3);
hold on
semilogx(100*rcFinal(1,:),'g','LineWidth',3);
semilogx(100*crFinal(1,:),'b','LineWidth',3);
semilogx(100*ccFinal(1,:),'c','LineWidth',3);
%{
semilogx(rrFinal(1,:)-rrFinal(2,:),'r');
semilogx(rrFinal(1,:)+rrFinal(2,:),'r');

semilogx(rcFinal(1,:)-rcFinal(2,:),'g');
semilogx(rcFinal(1,:)+rcFinal(2,:),'g');

semilogx(crFinal(1,:)-crFinal(2,:),'b');
semilogx(crFinal(1,:)+crFinal(2,:),'b');

semilogx(ccFinal(1,:)-ccFinal(2,:),'c');
semilogx(ccFinal(1,:)+ccFinal(2,:),'c');
%}
legend('Agents: r  Targets: r','Agents: r  Targets: c','Agents: c  Targets: r','Agents: c  Targets: c')
legend boxoff
xlim([0 100])
ylim([0 100])
title('Comparing Initialization Schemes')
xlabel('Time Steps')
ylabel('Percent of Targets Found')
%{
for a = 1:10
    vec = rc(j(a):(j(a+1)-1));
    convergeJ(a,:) = [vec' ones(1,maxLen-length(vec))];
end
rcFinal = zeros(2,maxLen);
for b = 1:maxLen
    rcFinal(1,b) = mean(convergeJ(:,b));
    rcFinal(2,b) = std(convergeJ(:,b));
end
%errorbar(rcFinal(1,:),rcFinal(2,:))

for a = 1:10
    vec = cr(k(a):(k(a+1)-1));
    convergeK(a,:) = [vec' ones(1,maxLen-length(vec))];
end
crFinal = zeros(2,maxLen);
for b = 1:maxLen
    crFinal(1,b) = mean(convergeK(:,b));
    crFinal(2,b) = std(convergeK(:,b));
end
%errorbar(crFinal(1,:),crFinal(2,:))

for a = 1:10
    vec = cc(l(a):(l(a+1)-1));
    convergeL(a,:) = [vec' ones(1,maxLen-length(vec))];
end
ccFinal = zeros(2,maxLen);
for b = 1:maxLen
    ccFinal(1,b) = mean(convergeL(:,b));
    ccFinal(2,b) = std(convergeL(:,b));
end
errorbar(ccFinal(1,:),ccFinal(2,:))
%}