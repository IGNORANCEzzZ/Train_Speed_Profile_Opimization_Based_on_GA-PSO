function [Population_G1]=InitPopulationForPSO()
%% ���
% Population_G1��1*n��Ԫ�����飬ÿ��Ԫ������һ��������8*4�Ĺ����л�����
%%
global Population_Size_PSO;
Population_G1=cell(1,Population_Size_PSO);
[Subinterval]=Subinterval_Division();%�����仮��
for i=1:1:Population_Size_PSO
    Population_G1{1,i}=InitSwitchPoint(Subinterval);
end
end