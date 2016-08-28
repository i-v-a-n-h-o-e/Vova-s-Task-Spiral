% Основная программа, интегрирующая систему с параметрами из файла info.mat
clearvars; tic;
load info.mat % Загрузка файла с параметрами
%% Выделение памяти
% Координаты состояния
trj.Ro = zeros(ceil(par.t12/par.T0)+1,1);
trj.Phi = zeros(ceil(par.t12/par.T0)+1,1);
trj.Z = zeros(ceil(par.t12/par.T0)+1,1);
% Производные координат состояния
trj.Der.Ro = zeros(ceil(par.t12/par.T0)+1,1);
trj.Der.Phi = zeros(ceil(par.t12/par.T0)+1,1);
trj.Der.Z = zeros(ceil(par.t12/par.T0)+1,1);
% Вариации координат состояния
trj.v.Ro = zeros(ceil(par.t12/par.T0)+1,1);
trj.v.Phi = zeros(ceil(par.t12/par.T0)+1,1);
trj.v.Z = zeros(ceil(par.t12/par.T0)+1,1);
%Управление
u1 = zeros(ceil(par.t12/par.T0)+1,1);
u2 = zeros(ceil(par.t12/par.T0)+1,1);
%% Начальные условия
trj.Ro(1) = par.R0;
trj.Phi(1) = par.Phi0;
trj.Z(1) = par.Z0;

trj.Der.Ro(1) = par.V * cos(par.alpha + u1(1)) * sin(par.beta + u2(1));
trj.Der.Phi(1) = par.V / trj.Ro(1) * cos(par.alpha + u1(1)) * cos(par.beta + u2(1));
trj.Der.Z(1) = - par.V * sin(par.alpha+u1(1));

trj.v.Ro(1) = trj.Pr.Ro(1) - trj.Ro(1);
trj.v.Phi(1) = trj.Pr.Phi(1) - trj.Phi(1);
trj.v.Z(1) = trj.Pr.Z(1) - trj.Z(1);
%% Интегрирование методом Адамса
for i = 2:(ceil(par.t12/par.T0)+1)
   trj.v.Ro(i) = trj.Pr.Ro(i-1) - trj.Ro(i-1);
   trj.v.Phi(i) = trj.Pr.Phi(i-1) - trj.Phi(i-1);
   trj.v.Z(i) = trj.Pr.Z(i-1) - trj.Z(i-1);
   
   u1(i) = 0;
   u2(i) = 0;
   
   trj.Der.Ro(i) = par.V * cos(par.alpha + u1(i)) * sin(par.beta + u2(i));
   trj.Ro(i) = trj.Ro(i-1) + trj.Der.Ro(i) * par.T0;
   trj.Der.Phi(i) = par.V / trj.Ro(i) * cos(par.alpha + u1(i)) * cos(par.beta + u2(i));
   trj.Phi(i) = trj.Phi(i-1) + trj.Der.Phi(i) * par.T0;
   trj.Der.Z(i) = - par.V * sin(par.alpha+u1(i));
   trj.Z(i) = trj.Z(i-1) + trj.Der.Z(i) * par.T0; 
end;
% График фактической и программной траекторий
[trj.x, trj.y, trj.z] = cilinder2decart(trj.Ro,trj.Phi,trj.Z);
plot3(trj.x, trj.y, trj.z,'green'); hold on; grid on;
plot3(trj.Des.x, trj.Des.y, trj.Des.z,'red');
plot3(trj.Pr.x,trj.Pr.y,trj.Pr.z,'blue');
legend('Траектория','Желаемая','Программная');
% Вариации координат состояния относительно программной и желаемой траектории
figure;
subplot(3,1,1);
plot(trj.t,trj.v.Ro); grid on; hold on;
plot(trj.t,trj.Des.Ro-trj.Ro);
xlabel('t,c'); ylabel('\rho,m');
title('Вариации координат состояния');

subplot(3,1,2);
plot(trj.t,trj.v.Phi.*180./pi); grid on;
xlabel('t,c'); ylabel('\Phi, deg');
 
subplot(3,1,3);
plot(trj.t,trj.v.Z); grid on;
xlabel('t,c'); ylabel('Z, м');

figure;
subplot(2,3,1);
plot(trj.t,trj.Ro,'green'); grid on; hold on;
plot(trj.t,trj.Des.Ro,'red');
xlabel('t,c'); ylabel('\rho,m');

subplot(2,3,2);
plot(trj.t,trj.Phi.*180./pi,'green'); grid on;
xlabel('t,c'); ylabel('\Phi, deg');
title('Координаты состояния и их производные')
 
subplot(2,3,3);
plot(trj.t,trj.Z,'green'); grid on;
xlabel('t,c'); ylabel('Z,м');

subplot(2,3,4);
plot(trj.t,trj.Der.Ro,'green'); grid on; hold on;
plot(trj.t,trj.Des.Ro,'red');
xlabel('t,c'); ylabel('d\rho/dt,m/c');

subplot(2,3,5);
plot(trj.t,trj.Der.Phi.*180./pi,'green'); grid on;
xlabel('t,c'); ylabel('d\phi/dt, deg/c');
 
subplot(2,3,6);
plot(trj.t,trj.Der.Z,'green'); grid on;
xlabel('t,c'); ylabel('dZ/dt,м/c');
