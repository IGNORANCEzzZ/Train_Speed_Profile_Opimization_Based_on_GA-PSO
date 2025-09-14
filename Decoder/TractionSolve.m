   function [Pos,Velocity,Force,Time,Energy,Mode,f_punc]=TractionSolve(SwitchPoint)
%% ���룺
%SwitchPoint�������л���
%|�л�λ��|��������|�����л�λ������|�����л�λ������
%�л�λ�ã���λm
%�������ͣ�0-��Ч���� 1-ǣ�� 2-���� 3-���� 4-�ƶ�|5-������

%% ���
%Pos��λ�þ��󣬵�λm
%Velocity���ٶȾ��󣬵�λ��km/h
%Force����λ��N
%Time����λs
%Energy:��λ��kWh
%Mode: ATP�������ߵ�ÿ��λ����ɢ������ʹ�õĹ���
%|�������� |�����
%0-��Ч���� 1-ǣ�� 2-���� 3-���� 4-�ƶ� 5-������
global start_pos;
global end_pos;
global N;
global step_s;
global MaxCapacityV;%����������ߣ���ATP��������
global v0;
global vend;
global T;%����ʱ��Լ������λ��
global epsi_t; %ʱ��Լ�������
global v_average;%ƽ���ٶȣ�km/h
global alpha_Re; %�����ƶ�������
global Eta;%����Ч��

if end_pos>start_pos
    step=step_s;
else
    step=-step_s;
end
[row_SwitchPoint col_SwitchPoint]=size(SwitchPoint);

Pos=zeros(1,N+1);
Velocity=zeros(1,N+1);
Force=zeros(1,N+1);
Ft=zeros(1,N+1);
Fb=zeros(1,N+1);
Time=zeros(1,N+1);
Energy=zeros(1,N+1);
%|�������� |�����
Mode=[zeros(N+1,1) zeros(N+1,1)];

Pos(1,1)=start_pos;
Velocity(1,1)=v0;
Force(1,N+1)=0;
Time(1,1)=0;
Energy(1,1)=0;
Mode(N+1,1)=4;
Mode(1,2)=Pos(1,1);
for i=1:1:N
%     disp('i=')
%     disp(i)
%     disp('Pos(i)=')
%     disp(Pos(1,i))
    for j=1:1:row_SwitchPoint-1
        if step>0
            if Pos(1,i)>=SwitchPoint(j,1) && Pos(1,i)<SwitchPoint(j+1,1)
                mode=SwitchPoint(j,2);
                mode_next=SwitchPoint(j+1,2);
                break;
            end
        else
            if Pos(1,i)<=SwitchPoint(j,1) && Pos(1,i)>SwitchPoint(j+1,1)
                mode=SwitchPoint(j,2);
                mode_next=SwitchPoint(j+1,2);
                break;
            end
        end
    end
    if mode==1 && i~=N
%         disp('i=')
%         disp(i)
%         disp('mode=')
%         disp(mode)
        [curspeed,F] = CalculateOneStep('FP',Velocity(1,i),1,i);
        Velocity(1,i+1)=curspeed;
        Force(1,i)=F;
        Mode(i,1)=1;
        Pos(1,i+1)=Pos(1,i)+step;
        Mode(i+1,2)=Pos(1,i+1);
    elseif mode==2 && i~=N
%         disp('i=')
%         disp(i)
%         disp('mode=')
%         disp(mode)
%         disp('Pos(i)= ')
%         disp(Pos(i))
        [curspeed,F] = CalculateOneStep('CONST',Velocity(1,i),1,i);
%         disp('curspeed= ')
%         disp(curspeed)
        Velocity(1,i+1)=curspeed;
        Force(1,i)=F;
        Mode(i,1)=2;
        Pos(1,i+1)=Pos(1,i)+step;
        Mode(i+1,2)=Pos(1,i+1);
    elseif (mode==3||mode==5) && i~=N 
%         disp('i=')
%         disp(i)
%         disp('mode=')
%         disp(mode)  
%         disp('Pos(i)= ')
%         disp(Pos(i))
        [curspeed,F] = CalculateOneStep('C',Velocity(1,i),1,i);
        Velocity(1,i+1)=curspeed;
        Force(1,i)=F;
        Mode(i,1)=mode;
        Pos(1,i+1)=Pos(1,i)+step;
        Mode(i+1,2)=Pos(1,i+1);
    elseif mode==4 && i~=N
%         disp('i=')
%         disp(i)
%         disp('mode=')
%         disp(mode)
        V_connect=Velocity(1,i);
        V_connect_pre=Velocity(1,i);
        Velocity(1,i)=MaxCapacityV(1,i);
        curspeed=Velocity(1,i);
        j=i;
        if Velocity(1,i-1)>1
            while 1
                [curspeed,F] = CalculateOneStep('FB',Velocity(1,j),0,j-1);
                V_connect_pre=Velocity(1,j);
                j=j-1;
                V_connect=Velocity(1,j);
                
                Force(1,j)=F;
                Mode(j,1)=4;
                if Velocity(1,j+1)<=V_connect_pre && curspeed>=V_connect
                    break;
                end
                Velocity(1,j)=curspeed;
            end
        end
        %��������һ���㣬��Ϊ��һ��forѭ��������������
        if mode_next==1
            [curspeed,F] = CalculateOneStep('FP',Velocity(1,i),1,i);
        elseif mode_next==2
            [curspeed,F] = CalculateOneStep('CONST',Velocity(1,i),1,i);
        elseif mode_next==3|| mode_next==5
            [curspeed,F] = CalculateOneStep('C',Velocity(1,i),1,i);
        elseif mode_next==4
            [curspeed,F] = CalculateOneStep('FB',Velocity(1,i),1,i);
        else
            disp('�ƶ�ͣ��֮����ִ��󹤿�')
        end
        Velocity(1,i+1)=curspeed;
        Force(1,i)=F;
        Mode(i,1)=mode;
        Pos(1,i+1)=Pos(1,i)+step;
        Mode(i+1,2)=Pos(1,i+1);
    elseif i==N  
        V_connect=vend;
        V_connect_pre=vend;
        Velocity(1,i+1)=vend;
        Pos(1,i+1)=Pos(1,i)+step;
        Mode(i+1,2)=Pos(1,i+1);
        curspeed=vend;
        j=i+1;  
        if Velocity(1,i)>1
            while 1
%                 disp('j=')
%                 disp(j)
%                 disp('Pos(j)= ')
%                 disp(Pos(j))
%                 disp('curspeed= ')
%                 disp(curspeed)
%                 disp('V_connect= ')
%                 disp(V_connect)
                z=j+1;
                if z>N+1
                    z=N+1;
                end
                    [curspeed,F] = CalculateOneStep('FB',Velocity(1,j),0,j-1);
                    V_connect_pre=Velocity(1,j);
                    j=j-1;
                    Force(1,j)=F;
                    Mode(j,1)=4;
                    V_connect=Velocity(1,j);
                    if Velocity(1,z)<=V_connect_pre && curspeed>=V_connect
                        break;
                    end
                    Velocity(1,j)=curspeed;
            end
        else
            Mode(j-1,1)=Mode(j-2,1);
        end
        
    else   
%         disp('������Ч')
%         disp('i= ')
%         disp(i)
%         disp('Pos(i)= ')
%         disp(Pos(i))
    end   
%     if curspeed>MaxCapacityV(1,i+1)
%         curspeed=MaxCapacityV(1,i+1);
%     end   
end
for z=1:1:N
    if Velocity(1,z)~=0||Velocity(1,z+1)~=0
        Time(1,z+1)=Time(1,z)+step_s/((Velocity(1,z)+Velocity(1,z+1))*0.5/3.6);
    else
        Time(1,z+1)=Time(1,z)+1e15;
    end
    if Force(1,z)>=0
        Ft(1,z)=Force(1,z);
    else
        Fb(1,z)=-Force(1,z);
    end
    Energy(1,z+1)=Energy(1,z)+(Ft(1,z)*step_s/Eta-Eta*alpha_Re*Fb(1,z)*step_s)/3600000; 
end
if abs(Time(1,N+1)-T)>epsi_t
    f_punc=v_average*(Time(1,N+1)-T);
else
    f_punc=0;
end
end