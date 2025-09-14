function [wj,gradient,curve]=GetAddResistance()
%% 输出参数
% wj：附加阻力，单位kN
% wj，1：N，以起始站后一个点为初始点
%%
global Gradient;
global Curve;
global start_pos;
global end_pos;
global N;
global step_s;
global g;
global M;
global Gradient_After_Judge;

cur_pos=start_pos;
 %% 得到线路坡度矩阵
 %|公里标 |坡道千分数 |坡道类型
 %坡道类型
 %大下坡道：列车使用惰行工况时，列车加速运行，即Fs(x)+F0(v)<0，用3表示
 %大上坡道：列车采样最大能力牵引时，列车减速运行，即Ft-(Fs(x)+F0(v))<0,用1表示
 %连续坡道：除上述两种之外的坡道
 gradient=[zeros(N,1) zeros(N,1) zeros(N,1)];
 
 if end_pos>start_pos
       [row,col]=size(Gradient_After_Judge);
     for i=1:1:row
         if start_pos>=Gradient_After_Judge(i,1) &&start_pos<Gradient_After_Judge(i,3)
             break;
         end
     end
     start_flag=i;
     for j=1:1:N
         cur_pos=cur_pos+step_s;
         while(1)
         if cur_pos>=Gradient_After_Judge(start_flag,1) &&cur_pos<Gradient_After_Judge(start_flag,3)
             gradient(j,1)=cur_pos;
             gradient(j,2)=Gradient_After_Judge(start_flag,2);
             gradient(j,3)=Gradient_After_Judge(start_flag,4);
             break;
         else 
             start_flag=start_flag+1;
         end
         end
     end
 else
     [row,col]=size(Gradient_After_Judge);
     for i=1:1:row
         if start_pos>=Gradient_After_Judge(i,1) &&start_pos<Gradient_After_Judge(i,3)
             break;
         end
     end
     start_flag=i;
     for j=1:1:N
         cur_pos=cur_pos-step_s;
         while(1)
         if cur_pos>=Gradient_After_Judge(start_flag,1) &&cur_pos<Gradient_After_Judge(start_flag,3)
             gradient(j,1)=cur_pos;
             gradient(j,2)=-Gradient_After_Judge(start_flag,2);
             gradient(j,3)=Gradient_After_Judge(start_flag,4);
             break;
         else 
             start_flag=start_flag-1;
         end
         end
     end
 end
 %% 得到线路曲线矩阵
 cur_pos=start_pos;
  curve=zeros(1,N);
 if end_pos>start_pos
       [row,col]=size(Curve);
%      for i=1:1:row
%          if start_pos>=Curve(i,1) && start_pos<Curve(i,3)
%              break;
%          end
%      end
     for j=1:1:N
         cur_pos=cur_pos+step_s;
         start_flag=1;
         while(1)
             if cur_pos>=Curve(start_flag,1) && cur_pos<Curve(start_flag,3)
                 curve(1,j)=Curve(start_flag,2);
                 break;
             else
                 start_flag=start_flag+1;
                 if start_flag>row
                       curve(1,j)=0;
                       break;
                 end
             end
         end
     end
 else
     [row,col]=size(Curve);
%      for i=1:1:row
%          if start_pos>=Curve(i,1) &&start_pos<Curve(i,3)
%              break;
%          end
%      end
     start_flag=1;
     for j=1:1:N
         cur_pos=cur_pos-step_s;
         start_flag=1;
         while(1)
             if cur_pos>=Curve(start_flag,1) &&cur_pos<Curve(start_flag,3)
                 curve(1,j)=Curve(start_flag,2);
                 break;
             else
                 start_flag=start_flag-1;
                 if start_flag>row
                     curve(1,j)=0;
                     break;
                 end
             end
         end
     end
 end
 
 %% 得到单位附加阻力矩阵 单位KN
 wj=zeros(1,N+1);
 for i=1:1:N
     if curve(1,i)==0
         wj(1,i)=gradient(i,2)*M*g*10^-3;
     else
         wj(1,i)=(gradient(i,2)+600/curve(1,i))*M*g*10^-3;%单位kN
     end
 end
 wj(1,N+1)=0;
end
