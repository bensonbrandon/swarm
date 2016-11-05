function [ X,Y ] = randomPositions( N, agentSize )
%takes in the number of agents, N, and their size
%returns arrays of X and Y positions (x,y) such that no position overlaps
%with another, i.e. no two positions are within 2*agentSize

X = [];
Y = [];

while length(X)<N
    x = rand;
    y = rand;
    overlap = 0;
    for i = 1:length(X)
        dist = ((x-X(i))^2 + (y-Y(i))^2)^.5;
        if dist<= agentSize
            overlap = 1;
            break
        end
    end
    if ~overlap
        X = [X x];
        Y = [Y y];
    end
end

end

