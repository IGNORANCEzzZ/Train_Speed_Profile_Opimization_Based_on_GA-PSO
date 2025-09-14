function [Population_Crossed]=Cross(Population_Selected)
%% 
%交叉算子：线性重组
%交叉方式：每一次循环随机选取两个不同的但是基因数量（工况切换点数量）相同的父代，进行多点交叉（在这里选两个交叉点）
%两点交叉：在带交叉的两个父代中随机选择两个不同的交叉点（一共四个交叉点，两两对应，且对应的两个交叉点在不同的个体上是同一种类型的工况，且不能是牵引工况和制动工况）
%（不能是制动工况是可以确定的，但是能否是牵引工况有待商榷）
%然后在每个交叉点上进行线性重组
%%
global Population_Size;
global Pc;
%%
n=Population_Size-1;
for i=1:1:n   
    flag_canCross=1; 
    while0=1;
    while 1 %%随机选取两个个体用来交叉
        index_father=randi([1,n]);%随机选取的用来交叉的父代个体的index
        index_mother=randi([1,n]);%随机选取的用来交叉的母代个体的index
        [row_father,col_father]=size(Population_Selected{1,index_father});
        [row_mother,col_mother]=size(Population_Selected{1,index_mother});
        if index_mother~=index_father && row_father==row_mother %选取染色体基数量一样的进行交叉
            break;
        end
        while0=while0+1;
        if while0>=200
            flag_canCross=0;
            break;
        end
        
    end
    if flag_canCross==0
        disp('本次循环不进行交叉')
        continue;
    end
    epsi=rand;%每次线性重组的系数
    
    while1=1;
    flag_canCross1=1;
    while 1%随机选取第一个交叉点
        location_1=randi([1,row_father]);%第一个交叉点
        %要交叉的两个基因是同个类型的工况，且是显性基因
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
        disp('本次循环不进行交叉')
        continue;
    end
    
    while2=1;
    flag_canCross2=1;
    while 1
        while 1
            location_2=randi([1,row_father]);%第2个交叉点
            if location_2~=location_1
                break;
            end
        end
         %要交叉的两个基因是同个类型的工况，且是显性基因
        if Population_Selected{1,index_father}(location_2,2)==Population_Selected{1,index_mother}(location_2,2) && Population_Selected{1,index_father}(location_2,5)==1 && Population_Selected{1,index_father}(location_2,5)==1
            break;
        end
        while2= while2+1;
%         if  while2>=100
%             disp('本次循环不交叉第二个交叉点')
%             flag_canCross2=0;
%             break;
%         end
    end
    
    rand_cross=rand;
    % 交叉第一个点
    if rand_cross<=Pc
        Population_Selected{1,index_father}(location_1,1)=(1-epsi)* Population_Selected{1,index_father}(location_1,1)+epsi* Population_Selected{1,index_mother}(location_1,1);
        Population_Selected{1,index_mother}(location_1,1)=(1-epsi)* Population_Selected{1,index_mother}(location_1,1)+epsi* Population_Selected{1,index_father}(location_1,1);
    end
    %交叉第二个点
    if rand_cross<=Pc && flag_canCross2==1
        Population_Selected{1,index_father}(location_2,1)=(1-epsi)* Population_Selected{1,index_father}(location_2,1)+epsi* Population_Selected{1,index_mother}(location_2,1);
        Population_Selected{1,index_mother}(location_2,1)=(1-epsi)* Population_Selected{1,index_mother}(location_2,1)+epsi* Population_Selected{1,index_father}(location_2,1); 
    end
end
Population_Crossed=Population_Selected;
end
