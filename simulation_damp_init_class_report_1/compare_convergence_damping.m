
for n = [1,2,4,8]
    load(strcat('n100_bp',num2str(n),'_run1.mat'))
    eval(strcat('rc = n100_bp',num2str(n),'_r_c;'))

    i = zeros(11,1);
    index = 0;
    arrayExt = [-1;rc;0];
    for val = 2:length(arrayExt)
        if arrayExt(val-1)~=0 && arrayExt(val)==0
            index = index + 1;
            i(index) = val-1;
        end
    end
    iLength = diff(i);
    
    iMS = [mean(iLength),std(iLength)];

    maxLen = max([iLength]);

    convergeI = zeros(10,maxLen);

    index = 1;
    for a = 1:10
        vec = rc(index:index+iLength(a)-1);
        index = index + iLength(a);
        convergeI(a,:) = [vec' ones(1,maxLen-length(vec))];
    end

    rcFinal = zeros(2,maxLen);
    for b = 1:maxLen
        rcFinal(1,b) = mean(convergeI(:,b));
        rcFinal(2,b) = std(convergeI(:,b));
    end
    semilogx(100*rcFinal(1,:),'LineWidth',3)
    hold on
end
xlim([10 100])
ylim([50 100])
legend('b = .1','b = .2','b = .4','b = .8')
legend boxoff
title('Comparing Convergence Damping')
xlabel('Time Steps')
ylabel('Percent of Targets Found')
