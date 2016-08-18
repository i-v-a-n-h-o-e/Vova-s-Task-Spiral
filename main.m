clear all; tic;
load info.mat

trj.Ro = zeros(ceil(par.t12/par.T0)+1,1);
trj.Phi = zeros(ceil(par.t12/par.T0)+1,1);
trj.Z = zeros(ceil(par.t12/par.T0)+1,1);
u1 = zeros(ceil(par.t12/par.T0)+1,1);
u2 = u1;

trj.Ro(1) = par.Z0;
trj.Phi(1) = par.Phi0;
trj.Z(1) = par.Z0;

for i = 2:(ceil(par.t12/par.T0)+1)
   u1(i) = (trj.Ro(i-1)+ )
   trj.Ro(i) = trj.Ro(i-1) + par.V * cos(par.alpha + u1(i)) * sin(par.beta + u2(i)) * par.T0;
   trj.Phi(i) = trj.Phi(i) + par.V / trj.Ro(i) * cos(par.alpha + u1(i)) * cos(par.beta + u2(i)) * par.T0;
   trj.Z(i) = trj.Z(i-1) - par.V * sin(par.alpha+u1(i)); 
end;

[trj.x, trj.y, trj.z] = cilinder2decart(trj.Ro,trj.Phi,trj.Z);
plot3(trj.x, trj.y, trj.z); hold on; grid on;
plot3(trj.Des.x, trj.Des.y, trj.Des.z); 