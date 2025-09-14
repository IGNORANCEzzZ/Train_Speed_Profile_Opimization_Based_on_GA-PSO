function [Population_G1]=InitPopulationForPSO()
%% 输出
% Population_G1：1*n的元胞数组，每个元胞都是一个完整的8*4的工况切换数组
%%
global Population_Size_PSO;
Population_G1=cell(1,Population_Size_PSO);
[Subinterval]=Subinterval_Division();%子区间划分
for i=1:1:Population_Size_PSO
    Population_G1{1,i}=InitSwitchPoint(Subinterval);
end
end