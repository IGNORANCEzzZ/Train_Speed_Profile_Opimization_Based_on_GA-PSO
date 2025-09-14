function [Velocity_After,SwitchPoint_After,Mode_After,f_safe]=ATP_Treatment(Velocity_Pre,Mode_Pre)
%% 输入
%Velocity_Pre 限速防护前的曲线
%SwitchPoint_Pre 限速防护前的工况转换点
%Mode_Pre: ATP防护曲线的每个位置离散点上所使用的工况
%|工况类型 |公里标
%0-无效工况 1-牵引 2-恒速 3-惰行 4-制动
%% 输出
% Velocity_After 限速防护后的速度曲线
% SwitchPoint_After 限速防护后的概况转换点

%Mode_After: ATP防护曲线的每个位置离散点上所使用的工况
%|工况类型 |公里标
%0-无效工况 1-牵引 2-恒速 3-惰行 4-制动

%% global
global MaxCapacityV;%ATP曲线
global ATP_Mode;%ATP曲线对应的工况离散矩阵、
global direction;
global T;%运行时间约束，单位秒
global epsi_t; %时间约束的误差
global Dis_Space;% 1:N+1
%%
[~, len_Velocity_Pre]=size(Velocity_Pre);
Mode_After=Mode_Pre;
Velocity_After=Velocity_Pre;
f_safe=0;
for i=2:1:len_Velocity_Pre-1
    if Velocity_Pre(1,i)>MaxCapacityV(1,i)      
        Velocity_After(1,i)=MaxCapacityV(1,i);
%         disp('i= ')
%         disp(i)
%         disp('pos(i= )')
%         disp(Dis_Space(1,i))
%         disp('Velocity_Pre(1,i)=')
%         disp(Velocity_Pre(1,i))
%         disp('MaxCapacityV(1,i)=')
%         disp(MaxCapacityV(1,i))
        f_safe=f_safe+1;
        Mode_After(i-1,1)=ATP_Mode(i-1,1);
    end
end
[len_Mode_After,~]=size(Mode_After);

%|切换位置 | 工况类型 |工况切换位置上限|工况切换位置下限
%切换位置，单位m
%工况类型：0-无效工况 1-牵引 2-恒速 3-惰行 4-制动
SwitchPoint_Pre=[zeros(len_Mode_After,1) zeros(len_Mode_After,1) zeros(len_Mode_After,1) zeros(len_Mode_After,1)];

SwitchPoint_Pre(1,1)=Mode_After(1,2);
SwitchPoint_Pre(1,2)=Mode_After(1,1);
SwitchPoint_Pre(1,3)=Mode_After(1,2);
SwitchPoint_Pre(1,4)=Mode_After(1,2);
flag=1;

for i=1:1:len_Mode_After-1
    if (Mode_After(i,1)==4 && Mode_After(i+1,1)~=4)
        flag=flag+1;
        SwitchPoint_Pre(flag,1)=Mode_After(i,2);%切换位置
        SwitchPoint_Pre(flag,2)=Mode_After(i,1);%工况类型
        SwitchPoint_Pre(flag,3)=SwitchPoint_Pre(flag-1,1);%位置上限
    end
    if ((Mode_After(i,1)~=Mode_After(i+1,1) && Mode_After(i+1,1)~=4) || i==len_Mode_After-1)
        flag=flag+1;
        SwitchPoint_Pre(flag,1)=Mode_After(i+1,2);%切换位置
        SwitchPoint_Pre(flag,2)=Mode_After(i+1,1);%工况类型
        SwitchPoint_Pre(flag,3)=SwitchPoint_Pre(flag-1,1);%位置上限
    end
end
SwitchPoint_After=[zeros(flag,1) zeros(flag,1) zeros(flag,1) zeros(flag,1)];    
for i=1:1:flag
    SwitchPoint_After(i,1)=SwitchPoint_Pre(i,1);
    SwitchPoint_After(i,2)=SwitchPoint_Pre(i,2);
    SwitchPoint_After(i,3)=SwitchPoint_Pre(i,3);
    SwitchPoint_After(i,4)=SwitchPoint_Pre(i+1,1);
end
SwitchPoint_After(flag,3)=SwitchPoint_After(flag,1);
SwitchPoint_After(flag,4)=SwitchPoint_After(flag,1);

%% 统计运行时间、能耗、

end