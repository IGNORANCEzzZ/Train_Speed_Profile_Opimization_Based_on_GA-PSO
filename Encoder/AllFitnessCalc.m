function [Ranked_Fitness,Ranked_Population,AllFitness,Population]=AllFitnessCalc(Population_G1)
%%
%���ȸ���������Ⱥ�������߼���
%��θ���ATP���߶���Ⱥ�е����и���������ߺ͹�����������ͳ�Ƴ����ٵ�ɢ�������Ϊf_safe��
%��θ�����������г��������м�����������,ͳ�������ܺġ�����ʱ��ȣ�
%������Ⱥ�����и������Ӧ�ȣ����Ҹ�����Ӧ�ȶԣ�����������ģ���Ⱥ��������
%%
%���ȸ���������Ⱥ�������߼���
 [Pos,Velocity,Force,Time,Energy,Mode,f_punc]=cellfun(@TractionSolve,Population_G1,'un',0);
 
 %��θ���ATP���߶���Ⱥ�е����и���������ߺ͹�����������ͳ�Ƴ����ٵ�ɢ�������Ϊf_safe��
 [Velocity_After,SwitchPoint_After,Mode_After,f_safe]=cellfun(@ATP_Treatment,Velocity,Mode,'un',0);
 
 %��θ�����������г��������м�����������,ͳ�������ܺġ�����ʱ��ȣ�
 [Pos2,Velocity2,Force2,Time2,Energy2,Mode2,f_punc2]=cellfun(@TractionSolve,SwitchPoint_After,'un',0);
 
 %������Ⱥ�����и������Ӧ�ȣ���
 [AllFitness]=cellfun(@FitnessCalc,Energy2,f_safe,f_punc2,'un',0);
 Population=Population_G1;
 
 %������Ӧ�ȶԣ�����������ģ���Ⱥ��������
 AllFitness_M=cell2mat(AllFitness);%��Ԫ��ת���ɾ���
 [AllFitness_M_Ranked,ind]=sort(AllFitness_M);%[a,ind]=sort(b),a��b����֮��ľ���ind������ʽ
 Ranked_Fitness=num2cell(AllFitness_M_Ranked);%�Ѿ���ת����Ԫ��
 Ranked_Population=Population_G1(ind);%��������ʽ��Ԫ�������������
end