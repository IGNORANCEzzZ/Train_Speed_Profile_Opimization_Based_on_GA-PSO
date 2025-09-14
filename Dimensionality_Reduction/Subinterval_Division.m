function [Subinterval]=Subinterval_Division()

 %|公里标 |坡道千分数 |坡道类型
global gradient_after_judge;%起点和终点之间的坡道

%|坡道起点| 坡道千分数| 坡道终点| 坡道类型
global Gradient_After_Judge;%整条线路的坡道

global start_pos;%开始点位置，单位m
global end_pos;%结束点位置，单位m
global IsStop;
global Station;
global step_s;
 
[row_staion,~]=size(Station);
num_of_allGradient=length(Gradient_After_Judge);
%|子区间起点| 子区间终点| 该子区间是否有长大下坡-1表示有-0表示没有| 长大下坡的起点| 该子区间是否需要制动停车-1表示需要-0表示不需要 | 该区间是否是从车站起车-1表示需要-0表示不需要
Subinterval_before=[zeros(num_of_allGradient,1) zeros(num_of_allGradient,1) zeros(num_of_allGradient,1) zeros(num_of_allGradient,1) zeros(num_of_allGradient,1) zeros(num_of_allGradient,1)];

length_of_gradient=length(gradient_after_judge);
num_of_subinterval=0;

Subinterval_before(1,1)=start_pos;
for i=1:1:length_of_gradient-1
    if gradient_after_judge(i,3)==3 && gradient_after_judge(i+1,3)~=3
        num_of_subinterval=num_of_subinterval+1;
        Subinterval_before(num_of_subinterval,2)=gradient_after_judge(i,1);%子区间终点
        Subinterval_before(num_of_subinterval,3)=1;%该子区间有大下坡道
        for j=i:-1:2
            if gradient_after_judge(j,3)==3 && gradient_after_judge(j-1,3)~=3
               break; 
            end
        end
        Subinterval_before(num_of_subinterval,4)=gradient_after_judge(j-1,1);%大下坡道起点
        Subinterval_before(num_of_subinterval+1,1)=gradient_after_judge(i,1);%下个子区间起点
    end
    if IsStop %如果中间车站需要停车，那么需要把中间车站也作为上个子区间的终点和下个子区间的起点
        for z=1:1:row_staion
            if (gradient_after_judge(i,1)==Station(z,1))||(gradient_after_judge(i,1)<Station(z,1) && gradient_after_judge(i,1)+step_s>Station(z,1))
                num_of_subinterval=num_of_subinterval+1;
                Subinterval_before(num_of_subinterval,2)=Station(z,1);%子区间终点
                Subinterval_before(num_of_subinterval,5)=1;%该子区间需要停车制动到子区间终点
                Subinterval_before(num_of_subinterval+1,1)=Station(z,1);%下个子区间起点
            end
        end
    end
end
Subinterval_before(num_of_subinterval+1,2)=end_pos;%最后一个子区间
Subinterval_before(num_of_subinterval+1,5)=1;%最后一个区间吗，需要停车制动

Subinterval=[zeros(num_of_subinterval+1,1) zeros(num_of_subinterval+1,1) zeros(num_of_subinterval+1,1) zeros(num_of_subinterval+1,1)];
for i=1:1:num_of_subinterval+1
    Subinterval(i,1)=Subinterval_before(i,1);
    Subinterval(i,2)=Subinterval_before(i,2);
    Subinterval(i,3)=Subinterval_before(i,3);
    Subinterval(i,4)=Subinterval_before(i,4);
    Subinterval(i,5)=Subinterval_before(i,5);
end
[row_Subinterval,~]=size(Subinterval);
for i=1:1:row_Subinterval
    for j=1:1:row_staion
        if Subinterval(i,1)==Station(j,1)
            Subinterval(i,6)=1;
            break;
        end
    end
end
end