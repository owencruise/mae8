function [T, X, Y, Z, U, V, W] = satellite(Xo, Yo, Zo, Uo, Vo, Wo,...
    tstart, tend, maxthrust)
% SATELLITE takes in scalar arguments for the satellite's initial xyz
% position, initial xyz velocity, times that the engine is turned on and
% off, and the maximum thrust produced by the engine.  It outputs time,
% position, and velocity vectors for the duration of the satellite's
% journey.
% Call format: function [T, X, Y, Z, U, V, W] = satellite(Xo, Yo, Zo, 
% Uo, Vo, Wo, tstart, tend, maxthrust)

%% Define constants
global G M m R
G = 6.67408e-11; %Gravitational constant in m^3 * kg^-1 * s^-2
M = 5.97e24;     %Mass of Earth in kilograms
m = 1500;        %Mass of each satellite in kilograms
R = 6.37e6;      %Radius of Earth in meters



%% Set initial values
dist = 0; %Distance traveled in meters
n = 1;    %Counter for filling vector outputs
dt = 1;   %Time differential of 1 second (specified in instructions)

[T(n), X(n), Y(n), Z(n), U(n), V(n), W(n)] = deal(0, Xo, Yo, Zo,...
    Uo, Vo, Wo);



%% Populate vectors
while dist < 4.2e8
    
    [Thx, Thy, Thz] = engine(tstart, tend, maxthrust,...
        T(n), U(n), V(n), W(n)); %Thrust in x, y, and z directions
    
    T(n+1) = T(n) + dt; %Time
    
    U(n+1) = U(n) + (Thx/m - G * M *...
        X(n)/((X(n)^2 + Y(n)^2 + Z(n)^2)^(3/2))) * dt; %Velocity (X)
    
    V(n+1) = V(n) + (Thy/m - G * M *...
        Y(n)/((X(n)^2 + Y(n)^2 + Z(n)^2)^(3/2))) * dt; %Velocity (Y)
    
    W(n+1) = W(n) + (Thz/m - G * M *...
        Z(n)/((X(n)^2 + Y(n)^2 + Z(n)^2)^(3/2))) * dt; %Velocity (Z)
    
    X(n+1) = X(n) + U(n+1) * dt; %Position (X)
    
    Y(n+1) = Y(n) + V(n+1) * dt; %Position (Y)
    
    Z(n+1) = Z(n) + W(n+1) * dt; %Position (Z)
        
    dist = dist + sqrt((X(n+1) - X(n))^2 + (Y(n+1) - Y(n))^2 +...
        (Z(n+1) - Z(n))^2);
        
    n = n + 1;
        
end

% Delete the final value of each vector, since the distance traveled must
% be strictly less than 4.2e8 meters
[T, X, Y, Z, U, V, W] = deal(T(1:end-1),...
    X(1:end-1), Y(1:end-1), Z(1:end-1),...
    U(1:end-1), V(1:end-1), W(1:end-1));

end
