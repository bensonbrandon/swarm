d = 0:.001:.5;
locF = zeros(1,length(d));
for i = 1:length(locF)
    locF(i) = localityFunction(d(i),agentSize);
end
plot(d,locF)
title('Locality Function')
xlabel('Distance')
ylabel('Force')