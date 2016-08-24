% Основная программа, интегрирующая систему с параметрами из файла info.mat
clear all; tic;
load info.mat % Загрузка файла с параметрами
%% Выделение памяти
% Координаты состояния
trj.Ro = zeros(ceil(par.t12/par.T0)+1,1);
trj.Phi = zeros(ceil(par.t12/par.T0)+1,1);
trj.Z = zeros(ceil(par.t12/par.T0)+1,1);
% Вариации координат состояния
trj.v.Ro = zeros(ceil(par.t12/par.T0)+1,1);
trj.v.Phi = zeros(ceil(par.t12/par.T0)+1,1);
trj.v.Z = zeros(ceil(par.t12/par.T0)+1,1);
%Управление
u1 = zeros(ceil(par.t12/par.T0)+1,1);
u2 = u1;
%% Начальные условия
trj.Ro(1) = par.Z0;
trj.Phi(1) = par.Phi0;
trj.Z(1) = par.Z0;

trj.v.Ro(1) = trj.Des.Ro(1) - trj.Ro(1);
trj.v.Phi(1) = trj.Des.Phi(1) - trj.Phi(1);
trj.v.Z(1) = trj.Des.Z(1) - trj.Z(1);
%% Интегрирование методом Адамса
for i = 2:(ceil(par.t12/par.T0)+1)
   trj.v.Ro(i) = trj.Des.Ro(i-1) - trj.Ro(i-1);
   trj.v.Phi(i) = trj.Des.Phi(i-1) - trj.Phi(i-1);
   trj.v.Z(i) = trj.Des.Z(i-1) - trj.Z(i-1);
   
   u1(i) = -3*trj.v.Z(i);
   u2(i) = trj.v.Z(i);
   trj.Ro(i) = trj.Ro(i-1) + par.V * cos(par.alpha + u1(i)) * sin(par.beta + u2(i)) * par.T0;
   trj.Phi(i) = trj.Phi(i) + par.V / trj.Ro(i) * cos(par.alpha + u1(i)) * cos(par.beta + u2(i)) * par.T0;
   trj.Z(i) = trj.Z(i-1) - par.V * sin(par.alpha+u1(i)); 
end;
% График фатической и желаемой траекторий
[trj.x, trj.y, trj.z] = cilinder2decart(trj.Ro,trj.Phi,trj.Z);
plot3(trj.x, trj.y, trj.z); hold on; grid on;
plot3(trj.Des.x, trj.Des.y, trj.Des.z);
% Вариации координат состояния
figure;
%subplot(3,1,1);
plot(trj.t,trj.v.Ro); grid on;
xlabel('t,c'); ylabel('/Rho,m');

subplot(3,1,2);
plot(trj.t,trj.v.Phi.*180./pi); grid on;
xlabel('t,c'); ylabel('\Phi, deg');
 
subplot(3,1,3);
% plot(trj.t,trj.v.Z); grid on;
% xlabel('t,c'); ylabel('Z, м');