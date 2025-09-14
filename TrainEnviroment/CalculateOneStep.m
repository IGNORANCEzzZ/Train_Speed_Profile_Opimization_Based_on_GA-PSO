function [curspeed,F] = CalculateOneStep(mode,preSpeed,Forward,k)
%��������������Ǽ���x+dx��x-dx�����ٶȣ�ȡ����Forward��ֵ
%���������
     %mode����ǰ����
     %preSpeed����ǰλ�õ��ٶ�,km/h
     %Forward�������Ǽ���x+dx���ٶȻ��Ǽ���x-dx���ٶȣ���������������㻹�Ƿ��㣬���������޹�
     %k,��ɢ�ռ���ĵڼ���λ��
%���������
     %curspeed��x+dx��x-dx�����ٶ�km/h
     %F:x��x+dx��x-dx��һ�������г���ʹ�õ�������λN
%%
global M;       %�г����� t
global g;       %�������ٶ�
global step_s;   %���벽�� m
global wj;
global SpdLimit; 
global MaxSpeed;
%%
x_step=step_s;
BasicForce=GetBasicResistance(preSpeed)*M*g;%N
%���ٶȵõ����г�������������

AdditionalForce=wj(k)*1000;%N
%���г�����λ�ã��µ����õ����µ��������������������ߺ��������������������µ�����������

%%
switch (mode)  
    case 'FP'
        TractionForce=GetTractionForce(preSpeed)*1000;%ԭ�����ĵ�λ��KN�����������1000���N
        %���ٶȵõ������ǣ����
        BreakForce=0; 
        %�����ƶ���
        F=TractionForce-BreakForce;  
    case 'CONST'
        F=BasicForce+AdditionalForce;
        if F>GetTractionForce(preSpeed)*1000
            F=GetTractionForce(preSpeed)*1000;
        end
        if F<-GetMaxBrakeForce(preSpeed)*1000
            F=-GetMaxBrakeForce(preSpeed)*1000;
        end
    case 'C'
        TractionForce=0;
        BreakForce=0;
        F=TractionForce-BreakForce;
    case 'FB'
        TractionForce=0;
        BreakForce=GetMaxBrakeForce(preSpeed)*1000;%ԭ�����ĵ�λ��KN�����������1000���N
        %���ٶȵõ������ƶ����ĺ���
        F=TractionForce-BreakForce;
end
 a=(F-BasicForce-AdditionalForce)/(M*1000);
%     disp('k= ')
%     disp(k)
%     disp('preSpeed= ')
%     disp(preSpeed)
%     disp('F= ')
%     disp(F)
%     disp('BasicForce= ')
%     disp(BasicForce)
%     disp('AdditionalForce= ')
%     disp(AdditionalForce)
%     disp('a= ')
%     disp(a)
%%
%a�Ǽ��ٶȣ�a(m/s^2)=F/m(N/kg),M�ĵ�λ�Ƕ֣�������Ҫ����1000���Kg
if preSpeed>MaxSpeed
    preSpeed=MaxSpeed;
end
if preSpeed<0
    preSpeed=0;
end
preSpeed=preSpeed/3.6;%��ǧ��ÿСʱת����m/s
%����3.6��ʲô��˼���
    if Forward
        %���Forward=1����curspeed���ǣ�prePos+dx�������ٶ�
        zz=preSpeed*preSpeed+2*x_step*a;
        if zz<0
            zz=0;
        end
        curspeed=sqrt(zz)*3.6;%��m/sת����km/h
        %��ʽ��V^2-VO^2=2aL��V^2=V0^2+2*dx*a
        if curspeed>MaxSpeed
            curspeed=MaxSpeed;
            a=((curspeed/3.6)*(curspeed/3.6)-(preSpeed)*(preSpeed))/(2*x_step);
            F=a*(M*1000)+BasicForce+AdditionalForce;
        end
    else
        %���Forward=0����curspeed���ǣ�prePos-dx�������ٶ�
        zz=preSpeed*preSpeed-2*x_step*a;
        if zz<0
            zz=0;          
        end
        curspeed=sqrt(zz)*3.6;%��m/sת����km/h
        if curspeed>MaxSpeed
            curspeed=MaxSpeed;
            a=((preSpeed)*(preSpeed)-(curspeed/3.6)*(curspeed/3.6))/(2*x_step);
            F=a*(M*1000)+BasicForce+AdditionalForce;
        end
    end
    
end