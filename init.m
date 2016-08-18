clc; clear all; tic;

par.R0 = 1;
par.Phi0 = 0;
par.Z0 = 10;
par.Us = 5 * pi / 180;
par.alpha = 10 * pi / 180;
par.beta = -1 * pi / 180;
par.V = 1;
par.t12 = 130;
par.T0 = 0.001;

trj.Pr.Ro = zeros(ceil(par.t12/par.T0)+1,1);
trj.Pr.Phi = zeros(ceil(par.t12/par.T0)+1,1);
trj.Pr.Z = zeros(ceil(par.t12/par.T0)+1,1);

trj.Des.Ro = zeros(ceil(par.t12/par.T0)+1,1);
trj.Des.Phi = zeros(ceil(par.t12/par.T0)+1,1);
trj.Des.Z = zeros(ceil(par.t12/par.T0)+1,1);

trj.t = 0:par.T0:par.t12;
trj.nu = 0.05 * sin(20 * pi * trj.t);
trj.eta = -0.05 * cos(20 * pi * trj.t);

trj.Pr.Ro(1) = par.Z0;
trj.Pr.Phi(1) = par.Phi0;
trj.Pr.Z(1) = par.Z0;

for i = 2:(ceil(par.t12/par.T0)+1)
    trj.Pr.Ro(i) = trj.Pr.Ro(i-1) + par.V * cos(par.alpha) * sin(par.beta) * par.T0;
    trj.Pr.Phi(i) = trj.Pr.Phi(i-1) + par.V / (trj.Pr.Ro(i)+trj.nu(i)) * cos(par.alpha) * cos(par.beta) * par.T0;
    trj.Pr.Z(i) = trj.Pr.Z(i-1) - par.V * sin(par.alpha) * par.T0;
end;

trj.Des.Ro = trj.Pr.Ro + trj.nu';
trj.Des.Phi = trj.Pr.Phi;
trj.Des.Z = trj.Pr.Z + trj.eta';

[trj.Pr.x, trj.Pr.y, trj.Pr.z] = cilinder2decart(trj.Pr.Ro,trj.Pr.Phi,trj.Pr.Z);
[trj.Des.x, trj.Des.y, trj.Des.z] = cilinder2decart(trj.Des.Ro,trj.Des.Phi,trj.Des.Z);
plot3(trj.Pr.x, trj.Pr.y, trj.Pr.z); hold on; grid on;
plot3(trj.Des.x, trj.Des.y, trj.Des.z); 

save info.mat trj par
toc;