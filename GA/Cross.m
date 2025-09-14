function [Population_Crossed]=Cross(Population_Selected)
%% 
%�������ӣ���������
%���淽ʽ��ÿһ��ѭ�����ѡȡ������ͬ�ĵ��ǻ��������������л�����������ͬ�ĸ��������ж�㽻�棨������ѡ��������㣩
%���㽻�棺�ڴ�������������������ѡ��������ͬ�Ľ���㣨һ���ĸ�����㣬������Ӧ���Ҷ�Ӧ������������ڲ�ͬ�ĸ�������ͬһ�����͵Ĺ������Ҳ�����ǣ���������ƶ�������
%���������ƶ������ǿ���ȷ���ģ������ܷ���ǣ�������д���ȶ��
%Ȼ����ÿ��������Ͻ�����������
%%
global Population_Size;
global Pc;
%%
n=Population_Size-1;
for i=1:1:n   
    flag_canCross=1; 
    while0=1;
    while 1 %%���ѡȡ����������������
        index_father=randi([1,n]);%���ѡȡ����������ĸ��������index
        index_mother=randi([1,n]);%���ѡȡ�����������ĸ�������index
        [row_father,col_father]=size(Population_Selected{1,index_father});
        [row_mother,col_mother]=size(Population_Selected{1,index_mother});
        if index_mother~=index_father && row_father==row_mother %ѡȡȾɫ�������һ���Ľ��н���
            break;
        end
        while0=while0+1;
        if while0>=200
            flag_canCross=0;
            break;
        end
        
    end
    if flag_canCross==0
        disp('����ѭ�������н���')
        continue;
    end
    epsi=rand;%ÿ�����������ϵ��
    
    while1=1;
    flag_canCross1=1;
    while 1%���ѡȡ��һ�������
        location_1=randi([1,row_father]);%��һ�������
        %Ҫ���������������ͬ�����͵Ĺ������������Ի���
        if Population_Selected{1,index_father}(location_1,2)==Population_Selected{1,index_mother}(location_1,2) && Population_Selected{1,index_father}(location_1,5)==1 && Population_Selected{1,index_father}(location_1,5)==1
            break;
        end
        while1=while1+1;
        if while1>=200
            flag_canCross1=0;
            break;
        end
    end
    
    if flag_canCross1==0
        disp('����ѭ�������н���')
        continue;
    end
    
    while2=1;
    flag_canCross2=1;
    while 1
        while 1
            location_2=randi([1,row_father]);%��2�������
            if location_2~=location_1
                break;
            end
        end
         %Ҫ���������������ͬ�����͵Ĺ������������Ի���
        if Population_Selected{1,index_father}(location_2,2)==Population_Selected{1,index_mother}(location_2,2) && Population_Selected{1,index_father}(location_2,5)==1 && Population_Selected{1,index_father}(location_2,5)==1
            break;
        end
        while2= while2+1;
%         if  while2>=100
%             disp('����ѭ��������ڶ��������')
%             flag_canCross2=0;
%             break;
%         end
    end
    
    rand_cross=rand;
    % �����һ����
    if rand_cross<=Pc
        Population_Selected{1,index_father}(location_1,1)=(1-epsi)* Population_Selected{1,index_father}(location_1,1)+epsi* Population_Selected{1,index_mother}(location_1,1);
        Population_Selected{1,index_mother}(location_1,1)=(1-epsi)* Population_Selected{1,index_mother}(location_1,1)+epsi* Population_Selected{1,index_father}(location_1,1);
    end
    %����ڶ�����
    if rand_cross<=Pc && flag_canCross2==1
        Population_Selected{1,index_father}(location_2,1)=(1-epsi)* Population_Selected{1,index_father}(location_2,1)+epsi* Population_Selected{1,index_mother}(location_2,1);
        Population_Selected{1,index_mother}(location_2,1)=(1-epsi)* Population_Selected{1,index_mother}(location_2,1)+epsi* Population_Selected{1,index_father}(location_2,1); 
    end
end
Population_Crossed=Population_Selected;
end
