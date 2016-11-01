function [force] = mySideFunction(dist)
if dist>.02
    force = dist/.02;
else
    force = (.02/dist)^.5;
end
