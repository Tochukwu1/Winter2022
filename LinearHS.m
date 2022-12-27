clear all
close all
clc

function yDot = ClosedLoopDynamics(t,y,P)
     x = y(); % row X-X in y vector;
     xd1_2 = -(1/3)*cos(3*t)-1/2*cos(2*t)-cos(t)-1/5*cos(5*t)-1/7*cos(7*t)...
         -1/11*cos(11*t);
     xd1_1 =  xd1_2;
end

function xDot = Dynamics(t, x, u, P)
x1Dot = x(2);
x2Dot = x(3);
x3Dot = [2,3,1,5,7,3;1,2,1,8,1,3]*[x(1);x(2);x(3)] + [1;3]*u;
    xDot = [x1Dot;x2Dot;x3Dot];
end