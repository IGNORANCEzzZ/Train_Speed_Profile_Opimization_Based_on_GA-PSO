function [SwitchPoint]=InitSwitchPoint(Subinterval)
%% 输出
% SwitchPoint：工况切换点
%|切换位置，单位m| 工况类型 |工况切换位置上限|工况切换位置下限|基因显隐性1-显性 0-隐形
%工况类型：0-无效工况 1-牵引 2-恒速 3-惰行 4-制动 5-过分相
%% 输入
%Subinterval:子区间
%|子区间起点| 子区间终点| 该子区间是否有长大下坡：1表示有 0表示没有| 长大下坡的起点| 该子区间是否需要制动停车 1表示需要 0表示不需要| 该区间是否是从车站起车-1表示需要-0表示不需要
%%
global step_s;
global start_pos;%开始点位置，单位m
global end_pos;%结束点位置，单位m
global Neutral_Section;%分相区

if end_pos>start_pos
    step=step_s;
    delta_m=1;
else
    step=-step_s;
    delta_m=-1;
end

[num_of_Subinterval,col]=size(Subinterval);
flag=0; %用以表征有几段需要制动停车的子区间
for i=1:1:num_of_Subinterval
    if Subinterval(i,5)==1
        flag=flag+1;
    end
end
num_of_SwitchPoint=3*num_of_Subinterval+flag;%一般的子区间只需要牵引、恒速、惰行三种工况，需要停车的子区间再多一个制动工况

%|切换位置 | 工况类型 |工况切换位置上限|工况切换位置下限| 基因显隐性
%切换位置，单位m
%工况类型：0-无效工况 1-牵引 2-恒速 3-惰行 4-制动
SwitchPoint=[zeros(num_of_SwitchPoint,1) zeros(num_of_SwitchPoint,1) zeros(num_of_SwitchPoint,1) zeros(num_of_SwitchPoint,1) ones(num_of_SwitchPoint,1)];

index=0;%表征SwitchPoint数组被填充了几个
for i=1:1:num_of_Subinterval
    if Subinterval(i,5)==1%需要制动停车的区间
        %工况类型
        SwitchPoint(index+1,2)=1;
        SwitchPoint(index+2,2)=2;
        SwitchPoint(index+3,2)=3;
        SwitchPoint(index+4,2)=4;
        
        %工况切换点上下限和切换位置
        %牵引工况切换点被固定为子区间起点
        SwitchPoint(index+1,3)=Subinterval(i,1);
        SwitchPoint(index+1,4)=Subinterval(i,1);
        SwitchPoint(index+1,1)=Subinterval(i,1);
        if Subinterval(i,6)==1%如果此区间牵引是从车站起车，那么其牵引工况应该是隐形基因，不再参与遗传操作
            SwitchPoint(index+1,5)=0;
        end
        
        %恒速工况
        SwitchPoint(index+2,3)=SwitchPoint(index+1,1);%上限
        if Subinterval(i,3)==1%该子区间有长大下坡
            SwitchPoint(index+2,4)=Subinterval(i,4);%下限是长大下坡起点
        else
            SwitchPoint(index+2,4)=Subinterval(i,2);%下限是子区间终点
        end
        SwitchPoint(index+2,1)=randi([min([SwitchPoint(index+2,3) SwitchPoint(index+2,4)]) max([SwitchPoint(index+2,3) SwitchPoint(index+2,4)])]);%上限和下限之间的随机整数
        
        %惰行工况
        SwitchPoint(index+3,3)=SwitchPoint(index+2,1);%上限
        SwitchPoint(index+3,4)=Subinterval(i,2);%下限是子区间终点
        SwitchPoint(index+3,1)=randi([min([SwitchPoint(index+3,3) SwitchPoint(index+3,4)]) max([SwitchPoint(index+3,3) SwitchPoint(index+3,4)])]);%上限和下限之间的随机整数
        
        %制动工况-制动工况采用反算的机制，所以记录的是工况终点，即子区间终点
        %         SwitchPoint(index+4,3)=SwitchPoint(index+3,1);%上限
        %         SwitchPoint(index+4,4)=Subinterval(i,2);%下限是子区间终点
        %         SwitchPoint(index+4,1)=randi([min([SwitchPoint(index+4,3) SwitchPoint(index+4,4)]) max([SwitchPoint(index+4,3) SwitchPoint(index+4,4)])]);%上限和下限之间的随机整数
        SwitchPoint(index+4,3)=Subinterval(i,2);%上限限是子区间终点
        SwitchPoint(index+4,4)=Subinterval(i,2);%下限是子区间终点
        SwitchPoint(index+4,1)=Subinterval(i,2);%制动工况终点是子区间终点
        SwitchPoint(index+4,5)=0;%制动停车工况不再参与遗传操作
        index=index+4;
    else
        %工况类型
        SwitchPoint(index+1,2)=1;
        SwitchPoint(index+2,2)=2;
        SwitchPoint(index+3,2)=3;
        
        %工况切换点上下限和切换位置
        %牵引工况切换点被固定为子区间起点
        SwitchPoint(index+1,3)=Subinterval(i,1);
        SwitchPoint(index+1,4)=Subinterval(i,1);
        SwitchPoint(index+1,1)=Subinterval(i,1);
        if Subinterval(i,6)==1%如果此区间牵引是从车站起车，那么其牵引工况应该是隐形基因，不再参与遗传操作
            SwitchPoint(index+1,5)=0;
        end
        
        %恒速工况
        SwitchPoint(index+2,3)=SwitchPoint(index+1,1);%上限
        if Subinterval(i,3)==1%该子区间有长大下坡
            SwitchPoint(index+2,4)=Subinterval(i,4);%下限是长大下坡起点
        else
            SwitchPoint(index+2,4)=Subinterval(i,2);%下限是子区间终点
        end
        SwitchPoint(index+2,1)=randi([min([SwitchPoint(index+2,3) SwitchPoint(index+2,4)]) max([SwitchPoint(index+2,3) SwitchPoint(index+2,4)])]);%上限和下限之间的随机整数
        
        %惰行工况
        SwitchPoint(index+3,3)=SwitchPoint(index+2,1);%上限
        SwitchPoint(index+3,4)=Subinterval(i,2);%下限是子区间终点
        SwitchPoint(index+3,1)=randi([min([SwitchPoint(index+3,3) SwitchPoint(index+3,4)]) max([SwitchPoint(index+3,3) SwitchPoint(index+3,4)])]);%上限和下限之间的随机整数
        
        index=index+3;
    end
end
for i=2:1:num_of_SwitchPoint
    if SwitchPoint(i,2)==1 && SwitchPoint(i-1,2)==4 && SwitchPoint(i,1)==SwitchPoint(i-1,1)
        SwitchPoint(i,1)=SwitchPoint(i,1)+step;
    end
end

%% 分相处理-存在问题：没有区分上下行
if ~isempty(Neutral_Section)
    [row_Neutral_Section,~]=size(Neutral_Section);
    index=1;%表征已经处理到哪个分相了
    num_of_SwitchPoint_Neu=0;
    num_of_SwitchPoint_after_Neutral=num_of_SwitchPoint+row_Neutral_Section*8;
    SwitchPoint_after_Neutral=zeros(num_of_SwitchPoint_after_Neutral,5);
    for i=1:1:num_of_SwitchPoint-1
        if index>row_Neutral_Section
            num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;
            SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,:)=SwitchPoint(i,:);
        else
            if  SwitchPoint(i+1,1)<Neutral_Section(index,1)
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,:)=SwitchPoint(i,:);
            elseif SwitchPoint(i+1,1)>=Neutral_Section(index,1) && SwitchPoint(i+1,1)<=Neutral_Section(index,2)
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,:)=SwitchPoint(i,:);
            elseif SwitchPoint(i+1,1)>Neutral_Section(index,2) && SwitchPoint(i,1)<Neutral_Section(index,1)%成功将电分相工况插入到原工况序列中
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%原工况
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,:)=SwitchPoint(i,:);
                
                len1=min(step_s*60,abs(SwitchPoint(i,1)-Neutral_Section(index,1)));
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%牵引
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,1)-delta_m*len1;%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=1;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint(i,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=Neutral_Section(index,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%恒速
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,1)-delta_m*len1*(2/3);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=2;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=Neutral_Section(index,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%惰行
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,1)-delta_m*len1*(1/3);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=3;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=Neutral_Section(index,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%过分相
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,1);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=5;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=Neutral_Section(index,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=Neutral_Section(index,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=0;
                
                len2=min(step_s*60,abs(SwitchPoint(i+1,1)-Neutral_Section(index,2)));
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%牵引
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,2);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=1;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=Neutral_Section(index,2);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=Neutral_Section(index,2);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=0;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%恒速
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,2)+delta_m*len2*(1/3);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=2;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=SwitchPoint(i+1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%惰行
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,2)+delta_m*len2*(2/3);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=3;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=SwitchPoint(i+1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%原工况
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,2)+delta_m*len2;%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=SwitchPoint(i,2);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=SwitchPoint(i+1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                index=index+1;
            elseif SwitchPoint(i,1)>=Neutral_Section(index,1) && SwitchPoint(i,1)<=Neutral_Section(index,2)
                
                len1=min(step_s*60,abs(SwitchPoint(i-1,1)-Neutral_Section(index,1)));
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%牵引
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,1)-delta_m*len1;%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=1;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint(i-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=Neutral_Section(index,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%恒速
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,1)-delta_m*len1*(2/3);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=2;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=Neutral_Section(index,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%惰行
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,1)-delta_m*len1*(1/3);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=3;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=Neutral_Section(index,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%过分相
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,1);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=5;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=Neutral_Section(index,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=Neutral_Section(index,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=0;
                
                len2=min(step_s*60,abs(SwitchPoint(i+1,1)-Neutral_Section(index,2)));
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%牵引
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,2);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=1;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=Neutral_Section(index,2);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=Neutral_Section(index,2);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=0;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%恒速
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,2)+delta_m*len2*(1/3);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=2;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=SwitchPoint(i+1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%惰行
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,2)+delta_m*len2*(2/3);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=3;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=SwitchPoint(i+1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%原工况
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,2)+delta_m*len2;%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=SwitchPoint(i,2);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=SwitchPoint(i+1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                index=index+1;
            end
        end
    end
    %最后一个工况
    num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;
    SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,:)=SwitchPoint(num_of_SwitchPoint,:);
    
% %     删除邻近相同工况
%     [row_SwitchPoint_after_Neutral,~]=size(SwitchPoint_after_Neutral);
%     index_same=0;
%     index_same_mat=[];
%     for i=2:1:row_SwitchPoint_after_Neutral
%         if SwitchPoint_after_Neutral(i,2)==SwitchPoint_after_Neutral(i-1,2)
%             index_same=index_same+1;
%             index_same_mat(1,index_same)=i;
%         end
%     end
%     SwitchPoint_after_Neutral(index_same_mat,:)=[];
    
    SwitchPoint_befor_Neutral=SwitchPoint;
    disp('SwitchPoint_befor_Neutral= ')
    disp(SwitchPoint_befor_Neutral)
    
    SwitchPoint=SwitchPoint_after_Neutral;
end
end