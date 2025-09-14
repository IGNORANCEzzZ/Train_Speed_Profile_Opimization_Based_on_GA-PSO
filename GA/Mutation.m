function [Population_Mutated]=Mutation(Population_Crossed)
%%
%变异操作：对每个个体的每个基因，以变异概率指定其为变异点
%对成为变异点的基因，将变异点前后的两个工况转换点位置以线性组合的方式生成新的工况转换点作为变异点的新的工况转换点
%%
global Population_Size;
global Pm;
%%
for i=1:1:Population_Size-1 %最后一个个体是最优本代最优个体不参与交叉变异
    [row,col]=size(Population_Crossed{1,i});
    for j=2:1:row-1
        rand_mutation=rand; 
        epsi=rand;
        if Population_Crossed{1,i}(j,5)==0|| rand_mutation>Pm%隐形基因不参与变异，随机数小于变异概率也不变异
            continue;
        else
            Population_Crossed{1,i}(j,1)=epsi*Population_Crossed{1,i}(j-1,1)+(1-epsi)*Population_Crossed{1,i}(j+1,1);
        end
    end
end
Population_Mutated=Population_Crossed;
end
