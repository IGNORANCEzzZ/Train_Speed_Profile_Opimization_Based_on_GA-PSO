function [Fitness_Selected,Population_Selected]=Select(Ranked_Fitness,Ranked_Population)
%% 采用排序选择+轮盘赌+最优个体保留策略的选择算子

%%
global Population_Size;
global c;
%%
Matrix_P=zeros(1,Population_Size);%给每个染色体赋予一个被选中的期望值所形成的矩阵
Matrix_P_Accumulated=zeros(1,Population_Size);%个体期望值进行前i个累计模拟轮盘
%不使用适应度函数的绝对值进行轮盘赌的原因是解决特别优秀的个体在种群选择中的影响，以及适应度为0的个体不可能被选择的问题
n=Population_Size;
for j=1:1:Population_Size
    Matrix_P(1,j)=(1/n)*(2-c+2*(c-1)*(j-1)/(n-1));
    if j==1
        Matrix_P_Accumulated(1,j)=Matrix_P(1,j);
    else
        Matrix_P_Accumulated(1,j)=Matrix_P_Accumulated(1,j-1)+Matrix_P(1,j);
    end
end
Fitness_Selected={};
Population_Selected={};
for i=1:1:Population_Size-1
    r=rand;
    [row,col]=find(Matrix_P_Accumulated<r);
    if isempty(col)
        col=zeros(1,1);
    end
    Fitness_Selected{1,i}=Ranked_Fitness{1,col(end)+1};
    Population_Selected{1,i}=Ranked_Population{1,col(end)+1};
end
Fitness_Selected{1,Population_Size}=Ranked_Fitness{1,1};
Population_Selected{1,Population_Size}=Ranked_Population{1,1};
end