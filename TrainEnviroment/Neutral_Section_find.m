function [Supply_Section, Neutral_Section]=Neutral_Section_find()
global start_pos;
global end_pos;
global N;
global step_s;
global Neutral;
global direction;
[row,col]=size(Neutral);

num_of_neu=0;%区间内分相区数量
for i=1:1:row
    if (Neutral(i,1)>=start_pos && Neutral(i,1)<=end_pos )||(Neutral(i,1)<=start_pos && Neutral(i,1)>=end_pos)
        num_of_neu=num_of_neu+1;
    end
end
index=0;
% 分相起点 | 分相终点
Neutral_Section=[zeros(num_of_neu,1) zeros(num_of_neu,1)];
for i=1:1:row
    if (Neutral(i,1)>=start_pos && Neutral(i,1)<=end_pos )||(Neutral(i,1)<=start_pos && Neutral(i,1)>=end_pos)
        index=index+1;
      if direction==2%上行
          Neutral_Section(index,1)=Neutral(i,1)-Neutral(i,2)/2;
          Neutral_Section(index,2)=Neutral(i,1)+Neutral(i,2)/2;
      else
          Neutral_Section(index,1)=Neutral(i,1)+Neutral(i,2)/2;
          Neutral_Section(index,2)=Neutral(i,1)-Neutral(i,2)/2;
      end
    end
end
% 公里标 | 所处第几个分相段
Supply_Section=[zeros(N+1,1) zeros(N+1,1)];
cur_pos=start_pos;
for i=1:1:N+1
    Supply_Section(i,1)=cur_pos;
    if cur_pos>Neutral(row,1)
        Supply_Section(i,2)=row+1;
    else
        for j=1:1:row
            if cur_pos< Neutral(j,1)
                Supply_Section(i,2)=j;
                break;
            end
        end
    end
    cur_pos=cur_pos+step_s;
end
end