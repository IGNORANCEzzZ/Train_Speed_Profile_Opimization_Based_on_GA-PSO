     function [Population_G1]=InitPopulation()
%% ���
% Population_G1��1*n��Ԫ�����飬ÿ��Ԫ������һ��������8*4�Ĺ����л�����
%%
global Population_Size;
Population_G1=cell(1,Population_Size);
[Subinterval]=Subinterval_Division();%�����仮��
for i=1:1:Population_Size
    Population_G1{1,i}=InitSwitchPoint(Subinterval);
end
end
