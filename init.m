%
% This program will calculate program and desired trajectory
% of control plant.
% Then, it saves in <info.mat> file in <trj> structure with <par>
% structure, which is contained all parameters of system,
% such as initial conditions, limit of control actions, system parameters
% ($/alpha, /beta, V$) and time and step of simulation.
clc; clearvars; tic;
%% Par structure creating
% initial conditions
par.R0 = 1; 
par.Phi0 = 0;
par.Z0 = 10;
% limit of control actions
par.Us = 5 * pi / 180;
% System parameters
par.alpha = 10 * pi / 180;
par.beta = -1 * pi / 180;
par.V = 1;
% time of simulation
par.t12 = 5; % [s]
% step of simulation
par.T0 = 0.001; %[s]

%% Memory allocation to trajectory structure, and its initialization
% Program
trj.Pr.Ro = zeros(ceil(par.t12/par.T0)+1,1);% Radius, m
trj.Pr.Phi = zeros(ceil(par.t12/par.T0)+1,1);% Polar angle, rad
trj.Pr.Z = zeros(ceil(par.t12/par.T0)+1,1);% Height, m
% Desired
trj.Des.Ro = zeros(ceil(par.t12/par.T0)+1,1);% Radius, m
trj.Des.Phi = zeros(ceil(par.t12/par.T0)+1,1);%  Polar angle, rad
trj.Des.Z = zeros(ceil(par.t12/par.T0)+1,1);% Height, m

trj.t = 0:par.T0:par.t12;%Сетка времени
trj.nu = 0.05 * sin(20 * pi * trj.t);
trj.eta = -0.05 * cos(20 * pi * trj.t);

trj.Pr.Ro(1) = par.R0;
trj.Pr.Phi(1) = par.Phi0;
trj.Pr.Z(1) = par.Z0;

%% Integrate program trajectory 
for i = 2:(ceil(par.t12/par.T0)+1)
    trj.Pr.Ro(i) = trj.Pr.Ro(i-1) + par.V * cos(par.alpha) * sin(par.beta) * par.T0;
    trj.Pr.Phi(i) = trj.Pr.Phi(i-1) + par.V / (trj.Pr.Ro(i)+trj.nu(i)) * cos(par.alpha) * cos(par.beta) * par.T0;
    trj.Pr.Z(i) = trj.Pr.Z(i-1) - par.V * sin(par.alpha) * par.T0;
end;
%% Calculate desired trajectory
trj.Des.Ro = trj.Pr.Ro + trj.nu';
trj.Des.Phi = trj.Pr.Phi;
trj.Des.Z = trj.Pr.Z + trj.eta';
%% coordinate tranformation and drawing plot
[trj.Pr.x, trj.Pr.y, trj.Pr.z] = cilinder2decart(trj.Pr.Ro,trj.Pr.Phi,trj.Pr.Z);
[trj.Des.x, trj.Des.y, trj.Des.z] = cilinder2decart(trj.Des.Ro,trj.Des.Phi,trj.Des.Z);
plot3(trj.Pr.x, trj.Pr.y, trj.Pr.z,'red'); hold on; grid on;
plot3(trj.Des.x, trj.Des.y, trj.Des.z,'blue');

save info.mat trj par
toc;