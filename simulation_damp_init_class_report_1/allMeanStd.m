allMean = zeros(4,8);
allStd = zeros(4,8);
for n = 1:8
    load(strcat('n100_bp',num2str(n),'_run1.mat'))
    eval(strcat('x = n100_bp',num2str(n),'_r_r;'))
    [avg,standev] = allMeanStdgetMS(x);
    allMean(1,n) = avg;
    allStd(1,n) = standev;
    load(strcat('n100_bp',num2str(n),'_run1.mat'))
    eval(strcat('x = n100_bp',num2str(n),'_r_c;'))
    [avg,standev] = allMeanStdgetMS(x);
    allMean(2,n) = avg;
    allStd(2,n) = standev;
    load(strcat('n100_bp',num2str(n),'_run1.mat'))
    eval(strcat('x = n100_bp',num2str(n),'_c_r;'))
    [avg,standev] = allMeanStdgetMS(x);
    allMean(3,n) = avg;
    allStd(3,n) = standev;
    load(strcat('n100_bp',num2str(n),'_run1.mat'))
    eval(strcat('x = n100_bp',num2str(n),'_c_c;'))
    [avg,standev] = allMeanStdgetMS(x);
    allMean(4,n) = avg;
    allStd(4,n) = standev;
end

allMean = round(allMean);
allStd = round(allStd);

for i = 1:8
    for j = 1:4
        string = strcat(num2str(allMean(j,i)),'$\pm $',num2str(allStd(j,i)));
        stringMS{j,i} = string;
    end
end

