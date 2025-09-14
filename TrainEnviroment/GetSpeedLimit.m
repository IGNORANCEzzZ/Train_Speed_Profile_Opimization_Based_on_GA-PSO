function [SpdLimit]=GetSpeedLimit(IsStop)
%% ���
% SpdLimit�����٣���λkm/h
% SpdLimit��1��N������ʼվ��һ����Ϊ��ʼ��
%% ����
% IsStop:�Ƿ����м�վͣ��

%% 
 global SpeedLimit;
 global Station;
 global start_pos;
 global end_pos;
 global N;
 global step_s;
 
 cur_pos=start_pos;
 Speed=SpeedLimit;
 [row_staion,col_station]=size(Station);
%% �õ���·���پ���
 SpdLimit=zeros(1,N+1);

 if end_pos>start_pos
     [row,col]=size(Speed);
     for i=1:1:row
         if start_pos>=Speed(i,1) &&start_pos<Speed(i,3)
             break;
         end
     end
     start_flag=i;
     for j=1:1:N+1
         cur_pos=cur_pos+step_s;
         if cur_pos>end_pos%����ĩβ�ķ���
             cur_pos=end_pos;
         end
         while(1)
             if cur_pos>=Speed(start_flag,1) &&cur_pos<Speed(start_flag,3)
                 SpdLimit(1,j)=Speed(start_flag,2);
                 break;
             else
                 start_flag=start_flag+1;
             end
         end
         if IsStop
             for i=1:1:row_staion
                 if (cur_pos==Station(i,1) && j~=N )||(cur_pos<Station(i,1) && cur_pos+step_s>Station(i,1)&& j~=N-1)
                     SpdLimit(1,j)=0;
                 end
             end
         end
     end
 else
     [row,col]=size(Speed);
     for i=1:1:row
         if start_pos>Speed(i,1) &&start_pos<=Speed(i,3)
             break;
         end
     end
     start_flag=i;
     for j=1:1:N+1
         if cur_pos<end_pos%����ĩβ�ķ���
             cur_pos=end_pos;
         end
         while(1)
             if cur_pos>Speed(start_flag,1) &&cur_pos<=Speed(start_flag,3)
                 SpdLimit(1,j)=Speed(start_flag,2);
                 break;
             else
                 start_flag=start_flag-1;
             end
         end
         if IsStop
             for i=1:1:row_staion
                 if (cur_pos==Station(i,1) && j~=N )||(cur_pos<Station(i,1) && cur_pos+step_s>Station(i,1)&& j~=N-1)
                     SpdLimit(1,j)=0;
                 end
             end
         end
         cur_pos=cur_pos-step_s;
     end
 end
end