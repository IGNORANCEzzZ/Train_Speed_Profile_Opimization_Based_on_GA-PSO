clc;
Global;
global SpdLimit;
global Dis_Space;% 1:N+1
global MaxCapacityV;%1:N+1
global ATP_F;
global ATP_T;
global ATP_Mode;%1:N+1

figure(1)
plot(Dis_Space,SpdLimit,'--r','LineWidth',1.5)
hold on
plot(Dis_Space,MaxCapacityV,':g','LineWidth',1.5)
hold on
plot(ATP_Mode(:,2),ATP_Mode(:,1)*10,'--b','LineWidth',1.0)
set(gca,'xdir','reverse')
legend('限速','ATP防护曲线','工况')
hold off

figure(2)
plot(Dis_Space,ATP_F,'b','LineWidth',1.0)
set(gca,'xdir','reverse')
hold off

[Subinterval]=Subinterval_Division();
 [SwitchPoint]=InitSwitchPoint(Subinterval);
% SwitchPoint=[4081,1,4081,4081;4000,2,4081,2806;4002,3,3329,2806;2806,4,2806,2806;2805,1,2806,2806;2663,2,2806,175;1859,3,2663,175;175,4,175,175];
[Pos,Velocity,Force,Time,Energy,Mode,f_punc]=TractionSolve(SwitchPoint);

figure(3)
plot(Dis_Space,SpdLimit,'--r','LineWidth',1.5)
hold on
plot(Dis_Space,MaxCapacityV,'-g','LineWidth',1.5)
hold on
plot(Pos,Velocity,'-b','LineWidth',1.5)
hold on
plot(Mode(:,2),Mode(:,1)*10,'--b','LineWidth',1.0)
hold on
plot(ATP_Mode(:,2),ATP_Mode(:,1)*10,'--m','LineWidth',1.0)
set(gca,'xdir','reverse')
legend('限速','ATP防护','解算曲线','解算曲线工况','ATP曲线工况')
hold off

[Velocity_After,SwitchPoint_After,Mode_After,f_safe]=ATP_Treatment(Velocity,Mode);

[Pos2,Velocity2,Force2,Time2,Energy2,Mode2,f_punc2]=TractionSolve(SwitchPoint_After);

figure(4)
plot(Dis_Space,SpdLimit,'--r','LineWidth',1.5)
hold on
plot(Dis_Space,MaxCapacityV,'-g','LineWidth',1.5)
hold on
plot(Pos,Velocity,'-b','LineWidth',1.5)
hold on
plot(Pos2,Velocity_After,'--k','LineWidth',1.5)
hold on
plot(Pos2,Velocity2,'-m','LineWidth',1.5)
hold on
plot(Mode(:,2),Mode(:,1)*10,'--b','LineWidth',1.0)
hold on
plot(ATP_Mode(:,2),ATP_Mode(:,1)*10,'--m','LineWidth',1.0)
set(gca,'xdir','reverse')
legend('限速','ATP防护','原解算曲线','修正后曲线','修正后解算曲线','解算曲线工况','ATP曲线工况')
hold off
