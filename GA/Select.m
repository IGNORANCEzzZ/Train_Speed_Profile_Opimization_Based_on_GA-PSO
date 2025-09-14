function [Fitness_Selected,Population_Selected]=Select(Ranked_Fitness,Ranked_Population)
%% ��������ѡ��+���̶�+���Ÿ��屣�����Ե�ѡ������

%%
global Population_Size;
global c;
%%
Matrix_P=zeros(1,Population_Size);%��ÿ��Ⱦɫ�帳��һ����ѡ�е�����ֵ���γɵľ���
Matrix_P_Accumulated=zeros(1,Population_Size);%��������ֵ����ǰi���ۼ�ģ������
%��ʹ����Ӧ�Ⱥ����ľ���ֵ�������̶ĵ�ԭ���ǽ���ر�����ĸ�������Ⱥѡ���е�Ӱ�죬�Լ���Ӧ��Ϊ0�ĸ��岻���ܱ�ѡ�������
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