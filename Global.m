% startup.m
base_path = fileparts(mfilename('fullpath'));  % 项目所在目录
addpath(genpath(fullfile(base_path, 'OptimizationOutputs')));
addpath(genpath(fullfile(base_path, 'PorjectInput_LineParameters')));
addpath(genpath(fullfile(base_path, 'TrainEnviroment')));
addpath(genpath(fullfile(base_path, 'GA')));
addpath(genpath(fullfile(base_path, 'Dimensionality_Reduction')));

%% 机车固定参数
global alpha_Re; %再生制动利用率
alpha_Re=0.7;
global Eta;%机车效率
Eta=0.9;
global g;%N/kg
g=9.81; 
global Y;%回转质量系数
Y=0.006;
global M;
M=440; %列车总重，t(k*kg)
global MaxSpeed;
MaxSpeed=350; %列车最大速度，km/h
global Auxiliary_Power;
Auxiliary_Power=300.15;%kw

%% 最大牵引、制动力、加速度约束
global Fd_max; %单位KN
Fd_max=532;
global Ft_max; %单位KN
Ft_max=225;
global a_max;%单位m/s^2
a_max=10;
global a_min;%单位m/s^2
a_min=-10;

%% 步长、空间离散点数
global step_s;%步长
step_s=1;
global startStation;
startStation=2;
global endStation;
endStation=3;
global Station %车站位置
Station = xlsread('03-线路参数','A1-A14车站');
global start_pos;%开始点位置，单位m
start_pos=Station(startStation);
global end_pos;%结束点位置，单位m
end_pos=Station(endStation);
global N;%x轴，距离离散点数
N=ceil(abs(start_pos-end_pos)/step_s);
global IsStop%用以表征是否中间车站停车
IsStop=1;
global direction;%上行-1 下行-2
if end_pos>start_pos %公里标递增，下行
    direction=2;
else
    direction=1;
end
%% 速度精度、速度离散点数
global step_v;
step_v=0.02;%m/s

global Speed_N;
Speed_N=ceil(MaxSpeed/3.6/step_v);

%% 预先读取的限速、坡度、曲线信息
global SpeedLimit;
SpeedLimit=xlsread('03-线路参数','A1-A14限速');
global Gradient;
Gradient = xlsread('03-线路参数','A1-A14坡度');
global Curve;
Curve = xlsread('03-线路参数','A1-A14曲线'); 
global Neutral;
Neutral=xlsread('03-线路参数','A1-A14分相');
global Gradient_After_Judge;
[Gradient_After_Judge]=GradientJudge();
global Neutral_Section;%分相区
global Supply_Section;%供电区段
[Supply_Section, Neutral_Section]=Neutral_Section_find();
%% 端点约束
global v0;
v0=0;
global vend;
vend=0;
global Fe0;
Fe0=225;%初始的列车牵引力-制动力???
global t0;
t0=0;

%% 准点约束
global T;%运行时间约束，单位秒
T=270; 
global epsi_t; %时间约束的误差
epsi_t=0.01*T;
% global lambda_T;%时间惩罚因子
% lambda_T=3500;
global t_exp; %子区间期望运行时间，单位s
global v_average;%平均速度，km/h
% v_average=abs(start_pos-end_pos)/T*3.6;
v_average=270;
t_exp=step_s/v_average/3.6;
%t_exp=0;
%% 预先得到的空间离散化的限速、线路附加阻力、坐标轴，最大能力曲线(ATP防护曲线)
global wj;% 1:N
global gradient_after_judge;
[wj,gradient_after_judge,~]=GetAddResistance();

global SpdLimit;
[SpdLimit]=GetSpeedLimit(IsStop);

global Dis_Space;% 1:N+1
global MaxCapacityV;%1:N+1
global ATP_F;
global ATP_T;
global ATP_Mode;%1:N+1
[Dis_Space,MaxCapacityV,ATP_F,ATP_T,ATP_Mode]=MaxCapacityCurve();

%% GA相关参数
global Population_Size;
Population_Size=100;
global Pc;
Pc=0.5;
global Pm
Pm=0.1;
global c;%给染色体赋予期望值的时候所用到的选择压力，c在0到1之间,c等于0是选择压力最大，适应度最小的个体不可能被选中；c=1选择压力最小
c=0.8;
global fitness_stop;
fitness_stop=35;

global Penalty_coefficient_safe;%罚函数系数
Penalty_coefficient_safe=10000;
global Penalty_coefficient_punc;%罚函数系数
Penalty_coefficient_punc=10000;

%% PSO相关参数
global Omega;%惯性权重
Omega=0.4;

%固定学习因子
global c1;
c1=2;
global c2;
c2=2;

global IterMax;
IterMax=300;
global Population_Size_PSO;
Population_Size_PSO=100;

%时变学习因子
global c1_i;
c1_i=2.5;
global c1_f;
c1_f=0.5;
global c2_i;
c2_i=0.5;
global c2_f;
c2_f=2.5;
