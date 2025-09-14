function [wj,gradient,curve]=GetAddResistance()
%% �������
% wj��������������λkN
% wj��1��N������ʼվ��һ����Ϊ��ʼ��
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
 %% �õ���·�¶Ⱦ���
 %|����� |�µ�ǧ���� |�µ�����
 %�µ�����
 %�����µ����г�ʹ�ö��й���ʱ���г��������У���Fs(x)+F0(v)<0����3��ʾ
 %�����µ����г������������ǣ��ʱ���г��������У���Ft-(Fs(x)+F0(v))<0,��1��ʾ
 %�����µ�������������֮����µ�
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
 %% �õ���·���߾���
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
 
 %% �õ���λ������������ ��λKN
 wj=zeros(1,N+1);
 for i=1:1:N
     if curve(1,i)==0
         wj(1,i)=gradient(i,2)*M*g*10^-3;
     else
         wj(1,i)=(gradient(i,2)+600/curve(1,i))*M*g*10^-3;%��λkN
     end
 end
 wj(1,N+1)=0;
end
