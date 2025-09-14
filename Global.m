% startup.m
base_path = fileparts(mfilename('fullpath'));  % ��Ŀ����Ŀ¼
addpath(genpath(fullfile(base_path, 'OptimizationOutputs')));
addpath(genpath(fullfile(base_path, 'PorjectInput_LineParameters')));
addpath(genpath(fullfile(base_path, 'TrainEnviroment')));
addpath(genpath(fullfile(base_path, 'GA')));
addpath(genpath(fullfile(base_path, 'Dimensionality_Reduction')));

%% �����̶�����
global alpha_Re; %�����ƶ�������
alpha_Re=0.7;
global Eta;%����Ч��
Eta=0.9;
global g;%N/kg
g=9.81; 
global Y;%��ת����ϵ��
Y=0.006;
global M;
M=440; %�г����أ�t(k*kg)
global MaxSpeed;
MaxSpeed=350; %�г�����ٶȣ�km/h
global Auxiliary_Power;
Auxiliary_Power=300.15;%kw

%% ���ǣ�����ƶ��������ٶ�Լ��
global Fd_max; %��λKN
Fd_max=532;
global Ft_max; %��λKN
Ft_max=225;
global a_max;%��λm/s^2
a_max=10;
global a_min;%��λm/s^2
a_min=-10;

%% �������ռ���ɢ����
global step_s;%����
step_s=1;
global startStation;
startStation=2;
global endStation;
endStation=3;
global Station %��վλ��
Station = xlsread('03-��·����','A1-A14��վ');
global start_pos;%��ʼ��λ�ã���λm
start_pos=Station(startStation);
global end_pos;%������λ�ã���λm
end_pos=Station(endStation);
global N;%x�ᣬ������ɢ����
N=ceil(abs(start_pos-end_pos)/step_s);
global IsStop%���Ա����Ƿ��м䳵վͣ��
IsStop=1;
global direction;%����-1 ����-2
if end_pos>start_pos %��������������
    direction=2;
else
    direction=1;
end
%% �ٶȾ��ȡ��ٶ���ɢ����
global step_v;
step_v=0.02;%m/s

global Speed_N;
Speed_N=ceil(MaxSpeed/3.6/step_v);

%% Ԥ�ȶ�ȡ�����١��¶ȡ�������Ϣ
global SpeedLimit;
SpeedLimit=xlsread('03-��·����','A1-A14����');
global Gradient;
Gradient = xlsread('03-��·����','A1-A14�¶�');
global Curve;
Curve = xlsread('03-��·����','A1-A14����'); 
global Neutral;
Neutral=xlsread('03-��·����','A1-A14����');
global Gradient_After_Judge;
[Gradient_After_Judge]=GradientJudge();
global Neutral_Section;%������
global Supply_Section;%��������
[Supply_Section, Neutral_Section]=Neutral_Section_find();
%% �˵�Լ��
global v0;
v0=0;
global vend;
vend=0;
global Fe0;
Fe0=225;%��ʼ���г�ǣ����-�ƶ���???
global t0;
t0=0;

%% ׼��Լ��
global T;%����ʱ��Լ������λ��
T=270; 
global epsi_t; %ʱ��Լ�������
epsi_t=0.01*T;
% global lambda_T;%ʱ��ͷ�����
% lambda_T=3500;
global t_exp; %��������������ʱ�䣬��λs
global v_average;%ƽ���ٶȣ�km/h
% v_average=abs(start_pos-end_pos)/T*3.6;
v_average=270;
t_exp=step_s/v_average/3.6;
%t_exp=0;
%% Ԥ�ȵõ��Ŀռ���ɢ�������١���·���������������ᣬ�����������(ATP��������)
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

%% GA��ز���
global Population_Size;
Population_Size=100;
global Pc;
Pc=0.5;
global Pm
Pm=0.1;
global c;%��Ⱦɫ�帳������ֵ��ʱ�����õ���ѡ��ѹ����c��0��1֮��,c����0��ѡ��ѹ�������Ӧ����С�ĸ��岻���ܱ�ѡ�У�c=1ѡ��ѹ����С
c=0.8;
global fitness_stop;
fitness_stop=35;

global Penalty_coefficient_safe;%������ϵ��
Penalty_coefficient_safe=10000;
global Penalty_coefficient_punc;%������ϵ��
Penalty_coefficient_punc=10000;

%% PSO��ز���
global Omega;%����Ȩ��
Omega=0.4;

%�̶�ѧϰ����
global c1;
c1=2;
global c2;
c2=2;

global IterMax;
IterMax=300;
global Population_Size_PSO;
Population_Size_PSO=100;

%ʱ��ѧϰ����
global c1_i;
c1_i=2.5;
global c1_f;
c1_f=0.5;
global c2_i;
c2_i=0.5;
global c2_f;
c2_f=2.5;
