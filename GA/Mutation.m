function [Population_Mutated]=Mutation(Population_Crossed)
%%
%�����������ÿ�������ÿ�������Ա������ָ����Ϊ�����
%�Գ�Ϊ�����Ļ��򣬽������ǰ�����������ת����λ����������ϵķ�ʽ�����µĹ���ת������Ϊ�������µĹ���ת����
%%
global Population_Size;
global Pm;
%%
for i=1:1:Population_Size-1 %���һ�����������ű������Ÿ��岻���뽻�����
    [row,col]=size(Population_Crossed{1,i});
    for j=2:1:row-1
        rand_mutation=rand; 
        epsi=rand;
        if Population_Crossed{1,i}(j,5)==0|| rand_mutation>Pm%���λ��򲻲�����죬�����С�ڱ������Ҳ������
            continue;
        else
            Population_Crossed{1,i}(j,1)=epsi*Population_Crossed{1,i}(j-1,1)+(1-epsi)*Population_Crossed{1,i}(j+1,1);
        end
    end
end
Population_Mutated=Population_Crossed;
end
