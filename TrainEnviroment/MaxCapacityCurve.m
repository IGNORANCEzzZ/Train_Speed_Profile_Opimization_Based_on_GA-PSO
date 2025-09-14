function [s,v,f,T,mode]=MaxCapacityCurve()
%% ���
%s��������ɢ�㣬1��N+1,����ʼվΪ��һ����
%v���ռ�����ɢ���Ż��ٶ����ߣ�1��N+1������ʼվΪ��һ����
%f:�г��������λ����ɢ���󣬵�λN
%T���ۼ�ʱ�䣬��λs
%mode: ATP�������ߵ�ÿ��λ����ɢ������ʹ�õĹ���
%|�������� |�����
%0-��Ч���� 1-ǣ�� 2-���� 3-���� 4-�ƶ�
%% ����
% IsStop���м�վ�Ƿ�ͣ���ı�־λ��1��ʾͣ��
%% 
global step_s;
global start_pos;
global end_pos;
global N;
global v0;
global vend;
global SpdLimit;
global MaxSpeed;

SpdLimit_Used=SpdLimit;
L=length(SpdLimit_Used);
for i=1:1:L
    if SpdLimit_Used(1,i)==MaxSpeed
        SpdLimit_Used(1,i)=SpdLimit_Used(1,i)-2;
    end
end
if end_pos>start_pos
    step=step_s;
else
   step=-step_s;
end

s=zeros(1,N+1);
v=zeros(1,N+1);
f=zeros(1,N+1);
%|�������� |�����
mode=[zeros(N+1,1) zeros(N+1,1)];
s(1,1)=start_pos;
v(1,1)=v0;
f(1,N+1)=0;

mode(N+1,1)=0;
mode(1,2)=s(1,1);
for i=1:1:N
    if v(1,i)<SpdLimit_Used(1,i+1)
        [curspeed,F] = CalculateOneStep('FP',v(1,i),1,i);
        v(1,i+1)=curspeed;
        f(1,i)=F;
        mode(i,1)=1;%ǣ������
        s(1,i+1)=s(1,i)+step;
        mode(i+1,2)=s(1,i+1); 
    end
    if v(1,i)==SpdLimit_Used(1,i+1)
        [v(1,i+1),F]=CalculateOneStep('CONST',v(1,i),1,i);
        f(1,i)=F;
        mode(i,1)=2;%���ٹ���
        s(1,i+1)=s(1,i)+step;
        mode(i+1,2)=s(1,i+1);
    end
    if v(1,i)>SpdLimit_Used(1,i+1)
        v(1,i+1)=v(1,i);
        s(1,i+1)=s(1,i)+step;
        f(1,i)=0;
        mode(i,1)=2;
        mode(i+1,2)=s(1,i+1);
    end
    if v(1,i)>SpdLimit_Used(1,i)%�ƶ�����
        if v(1,i)-SpdLimit_Used(1,i)>=4
            mode(i,1)=4;
        end
        v(1,i)=SpdLimit_Used(1,i);
        %�������괦��һ���㣬��i+1����ٶȡ�λ�ã�i������͹�������Ϊ����һ��forѭ�������㲻�ᱻ����
        if SpdLimit_Used(1,i+1)>v(1,i)
            [v(1,i+1),F]=CalculateOneStep('FP',v(1,i),1,i);
            mode(i+1,1)=1;%ǣ������
        elseif SpdLimit_Used(1,i+1)== v(1,i)
            [v(1,i+1),F]=CalculateOneStep('CONST',v(1,i),1,i);
            mode(i+1,1)=2;%���ٹ���
        elseif SpdLimit_Used(1,i+1)< v(1,i)
            [v(1,i+1),F]=CalculateOneStep('FB',v(1,i),1,i);
            mode(i+1,1)=4;%�ƶ�����
        else
            disp('�ƶ����ٻ�ͣ��֮����ִ��󹤿�')
        end
        f(1,i)=F;
        s(1,i+1)=s(1,i)+step;
        mode(i+1,2)=s(1,i+1);
        %�������괦��һ���㣬��i+1����ٶȡ�λ�ã�i������͹�������Ϊ����һ��forѭ�������㲻�ᱻ����
        
        %Ȼ���������ӳɹ��㼴j�㵽i-1����ٶȣ��Լ���Ӧ��j�㵽i-1������͹�����i����ٶ��Ѿ������汻�����˾͵���SpdLimit(1,i)
        j=i-1;
        [v_j,F]=CalculateOneStep('FB',v(1,j+1),0,j);
        while v_j<v(1,j)
            v(1,j)=v_j;
            f(1,j)=F;
            mode(j,1)=4;
            [v_j,F]=CalculateOneStep('FB',v(1,j),0,j-1);
            j=j-1;
        end
    end
    if i==N %�ƶ�ͣ��
        %���������ӵ㼴j�� �� ����N+1���λ�á��ٶȣ��Լ���Ӧ��j-1�㵽N-1������͹���
        v(1,i+1)=vend;
        s(1,i+1)=s(1,i)+step;
        mode(i+1,2)=s(1,i+1);      
        j=i;
        [v_j,F]=CalculateOneStep('FB',v(1,j+1),0,j);
        while v_j<v(1,j)
            v(1,j)=v_j;
            f(1,j)=F;
            mode(j,1)=4;
            [v_j,F]=CalculateOneStep('FB',v(1,j),0,j-1);
            j=j-1;
        end
    end
% x=['SpeedLimit= ',num2str(SpdLimit_Used(1,i)),' i= ',num2str(i),' v(1,i)= ',num2str(v(1,i))];
% disp(x);
end
T=0;
for z=1:1:N
    T=T+2*step_s./(v(1,z)/3.6+v(1,1+z)/3.6);
end

end