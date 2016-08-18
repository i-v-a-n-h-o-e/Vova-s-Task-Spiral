function [x, y, z] = cilinder2decart(Ro,Phi,Z)
    x = Ro .* cos(Phi);
    y = Ro .* sin(Phi);
    z = Z;
end