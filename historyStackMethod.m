
clear all
close all
clc
yalmip('clear')

%% Simulation parameters
P.n = 2; % dimension of states
P.l = 4; % dimension of unknown parameters
P.Gamma = 10; % Gain
%% Initial Conditions
tspan = [0 40];
P.x0 = [-1;1];  % initial actual states
P.xHat0 = [2;1];  % initial state estimates
P.theta0 = [1;1;1;1];
z0 = [P.x0;P.xHat0;P.theta0;zeros(P.n*P.l+P.l^2+P.l,1)]; % initial concatenated states

%% Simulation
options = odeset('OutputFcn',@odeplot, 'OutputSel', 1:2*P.n);
[t,z] = ode45(@(t,z) closedLoopDynamics(t,z, P), tspan, z0, options);

%% Results
e = z(:,1:P.n)-z(:,P.n+1:2*P.n); % observer error
%% Plots

% State estimation error between actual and estimated x-coordinates trajectories
p = plot(t, e, LineWidth=2);
mrk1={'s','v','o','*','^','x'};
mrk=(mrk1(1,1:size(p,1)))';
set(p,{'marker'},mrk,{'markerfacecolor'},get(p,'Color'),'markersize',5);
f_nummarkers(p,10,1);
for i=1:size(p,1)
    hasbehavior(p(i), 'legend', false);
end
title('State Estimation Error', 'FontSize',20,'Interpreter','latex')
xl = xlabel('$Time (s)$','interpreter','latex');
yl = ylabel('$e(t)$','interpreter','latex');
set(xl,'Fontsize',40);
set(yl,'Fontsize',40);
l = legend('$(e)_1$','$(e)_2$','interpreter','latex', 'Fontsize',20);
set(l,'Interpreter','latex','Location','NorthEast');
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [8 4]);
set(gcf, 'PaperPosition', [0 0 8 4]);
grid on

% Trajectory of actual states
figure
p = plot(t, z(:,1:P.n), LineWidth=2);
mrk1={'s','v','o','*','^','x'};
mrk=(mrk1(1,1:size(p,1)))';
set(p,{'marker'},mrk,{'markerfacecolor'},get(p,'Color'),'markersize',5);
f_nummarkers(p,10,1);
for i=1:size(p,1)
    hasbehavior(p(i), 'legend', false);
end
title('Trajectory of actual states', 'FontSize',20,'Interpreter','latex')
xl = xlabel('$Time (s)$','interpreter','latex');
yl = ylabel('$x(t)$','interpreter','latex');
set(xl,'Fontsize',40);
set(yl,'Fontsize',40);
l = legend('$(x)_1$(t)','$(x_2$(t)', 'interpreter','latex');
set(l,'Interpreter','latex','Location','NorthEast', 'Fontsize',20);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [8 4]);
set(gcf, 'PaperPosition', [0 0 8 4]);
grid on 


% Trajectory of Estimated states
figure
p = plot(t, z(:,P.n+1:P.n+P.n), LineWidth=2);
mrk1={'s','v','o','*','^','x'};
mrk=(mrk1(1,1:size(p,1)))';
set(p,{'marker'},mrk,{'markerfacecolor'},get(p,'Color'),'markersize',5);
f_nummarkers(p,10,1);
for i=1:size(p,1)
    hasbehavior(p(i), 'legend', false);
end
title('Trajectory of estimated states', 'FontSize',20,'Interpreter','latex')
xl = xlabel('$Time (s)$','interpreter','latex');
yl = ylabel('$\hat{x(t)}$','interpreter','latex');
set(xl,'Fontsize',40);
set(yl,'Fontsize',40);
l = legend('$\hat{x_1}$','$\hat{x_2}$', 'Interpreter','latex');
set(l,'Interpreter','latex','Location','NorthEast', 'Fontsize',20);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [8 4]);
set(gcf, 'PaperPosition', [0 0 8 4]);
grid on

% Parameter Estimates
figure
p = plot(t, z(:,2*P.n+1:2*P.n+P.l), LineWidth=2);
mrk1={'s','v','o','*','^','x'};
mrk=(mrk1(1,1:size(p,1)))';
set(p,{'marker'},mrk,{'markerfacecolor'},get(p,'Color'),'markersize',5);
f_nummarkers(p,10,1);
for i=1:size(p,1)
    hasbehavior(p(i), 'legend', false);
end
title('Parameter Estimates', 'FontSize',20,'Interpreter','latex')
xl = xlabel('$Time (s)$','interpreter','latex');
yl = ylabel('$\hat{\theta(t)}$','interpreter','latex');
set(xl,'Fontsize',40);
set(yl,'Fontsize',40);
l = legend('$\hat{\theta_{1}}$','$\hat{\theta_{2}}$','$\hat{\theta_{3}}$',...
    '$\hat{\theta_{4}}$','Interpreter','latex');
set(l,'Interpreter','latex','Location','NorthEast', 'Fontsize',20);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [8 4]);
set(gcf, 'PaperPosition', [0 0 8 4]);
grid on


%% Closed loop system
function zDot = closedLoopDynamics(t, z, P)

    x = z(1:P.n, :); % row 1-2 in z vector
    xHat = z(P.n+1:2*P.n,:); % row 3-4 in z vector
    thetaHat = z(2*P.n+1:2*P.n+P.l,1); % row 5-8 in z vector
    scriptYHat = reshape(z(2*P.n+P.l+1:2*P.n+P.l+P.n*P.l),P.n,P.l); % row 9-16 in z vector
    scriptYfHat = reshape(z(2*P.n+P.l+P.n*P.l+1:2*P.n+P.l+P.n*P.l+P.l^2),P.l,P.l); % row 17-32 in z vector
    scriptXfHat = z(2*P.n+P.l+P.n*P.l+P.l^2+1:2*P.n+P.l+P.n*P.l+P.l^2+P.l); % row 18-36 in z vector
    
    C = [1 0]; % output matrix
    y = C*x; % measured output
    P.q = size(y, 2); % Dimension of output;
    
    % Control estimate
    uHat = -(cos(2*xHat(1))+2)*xHat(2);
    u= -(cos(2*x(1))+2)*x(2);

    % Bounds on Derivative of Jacobian Matrix
    M1 = [[ 0,                           1]
          [2*x(2)*sin(2*x(1))*(cos(2*x(1))+2)-1, -(cos(2*x(1))+2)^2/2-1/2]];
    M2 = [[ 0,                           1]
          [6*abs(x(2))-1, -1/2]];
%     M2 = M1;
    
    
    % Multiplier matrices
    J = {zeros(P.n,P.n), -(M2.'-M1.')/2; -(M2-M1)/2, eye(P.n)};
    
    % Pole Placement 
    A = M1;

    % Decision variables
    Q = sdpvar(P.n,P.n); alpha = 0.1;
    H = sdpvar(P.n,P.q);
    R = sdpvar(P.n,P.q);
    
    % LMI Formulation
    J_21 = J{2,1}*(eye(P.n)-H*C);
    L_11 = A'*Q+Q*A- C.'*R.'-R*C;
    L_12 = Q-J_21.';
    L_21 = Q-J_21;
    L_22 = -(J{2,2});
    lmi = [L_11, L_12;L_21, L_22];

    % LMI Constraints
    F = [Q>=alpha*eye(P.n, P.n)];
    F = [F; lmi <= 0];

    % Solver
    ops = sdpsettings('solver', 'sedumi','verbose',1);
    
    % Diagnostics from LMI solver
    diagnostics = solvesdp(F, [], ops); %optimize(constraints, objective, options)
    
    % Check results of optimization
    if diagnostics.problem == 0
        disp('Feasible from solver')
    elseif diagnostics.problem == 1
        disp('Infeasible from solver')
    else
        disp('Error, something wrong occured')
    end
    
    % Results
    Q = double(Q); % positive definite matrix
    H = double(H); % observer gain
    R = double(R); % 
    L = Q\R; % observer gain

    % Remove this
    if isnan(H)
%         disp('error nan H')
        H = zeros(P.n,P.q);
    end

    if isnan(Q)
        disp('error nan Q')
        Q = ones(P.n,P.n);
    end

    
    if eig(Q) <= 0
        disp("Error")
    end
    
    % Actual dynamics
%     if t > 20
%         u = uHat;
%     end
    Y = [0     x(2)  0                           0;
        x(1)  0     x(2)*(1-(cos(2*x(1))+2)^2)  (cos(2*x(1))+2)*u]; % Actual Regressor Matrix
    theta = [-1 ; 1 ; -0.5 ; 1];  % Actual unknown parameters
    xDot = Y*theta;  % dynamics
    
    % State estimator dynamics
    thetaHat = [1;-1;-0.5;0.5]; % Change this, Just for testing !!!!!!!!!!!!! 
    s = xHat + H*(y-C*xHat); % nonlinear correction 
    YHat = [0, s(2), 0, 0;s(1), 0, s(2)*(1-(cos(2*s(1))+2)^2),...
            (cos(2*s(1))+2)*uHat]; % Regressor Matrix
    xHatDot = YHat*thetaHat+L*(y-C*xHat); % dynamics

    minEig = 0.01; % Threshold to turn off filters
    
    update = 1;
    if min(eig(scriptYfHat)) > minEig
        update = 0;
    end
    
%     zDot = [xDot;
%             xHatDot;
%             P.Gamma*(scriptXfHat - scriptYfHat*thetaHat);
%             reshape(YHat , P.n*P.l,1)* update;
%             reshape(scriptYHat.'*scriptYHat , P.l^2,1)* update;
%             scriptYHat.'*(xHat-P.xHat0) * update];

 zDot = [xDot;
            xHatDot;
          zeros(4,1);zeros(P.n*P.l+P.l^2+P.l,1)];
end





