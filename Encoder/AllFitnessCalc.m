function [Ranked_Fitness,Ranked_Population,AllFitness,Population]=AllFitnessCalc(Population_G1)
%%
%首先根据输入种群进行曲线计算
%其次根据ATP曲线对种群中的所有个体进行曲线和工况的修正，统计超限速的散点个数作为f_safe；
%其次根据修正后的列车操纵序列计算运行曲线,统计运行能耗、运行时间等；
%计算种群中所有个体的适应度，并且根据适应度对（工况修正后的）种群进行排序
%%
%首先根据输入种群进行曲线计算
 [Pos,Velocity,Force,Time,Energy,Mode,f_punc]=cellfun(@TractionSolve,Population_G1,'un',0);
 
 %其次根据ATP曲线对种群中的所有个体进行曲线和工况的修正，统计超限速的散点个数作为f_safe；
 [Velocity_After,SwitchPoint_After,Mode_After,f_safe]=cellfun(@ATP_Treatment,Velocity,Mode,'un',0);
 
 %其次根据修正后的列车操纵序列计算运行曲线,统计运行能耗、运行时间等；
 [Pos2,Velocity2,Force2,Time2,Energy2,Mode2,f_punc2]=cellfun(@TractionSolve,SwitchPoint_After,'un',0);
 
 %计算种群中所有个体的适应度；根
 [AllFitness]=cellfun(@FitnessCalc,Energy2,f_safe,f_punc2,'un',0);
 Population=Population_G1;
 
 %根据适应度对（工况修正后的）种群进行排序
 AllFitness_M=cell2mat(AllFitness);%把元胞转化成矩阵
 [AllFitness_M_Ranked,ind]=sort(AllFitness_M);%[a,ind]=sort(b),a是b排序之后的矩阵，ind是排序方式
 Ranked_Fitness=num2cell(AllFitness_M_Ranked);%把矩阵转化成元胞
 Ranked_Population=Population_G1(ind);%按照排序方式对元胞数组进行排序
end