function [ yp ] = masaresorte( t, y )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

m = 1;
k = 1;

w = 0.99;
c = 0.0001;

yp = zeros(2,1);

yp(1) = y(2);
yp(2) = (sin(w*t) - k*y(1) - c*y(2))/m;

% [t,y] = ode45(@masaresorte,[0 30000],[0 0]);

end

