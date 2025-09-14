function [Velocity_After,SwitchPoint_After,Mode_After,f_safe]=ATP_Treatment(Velocity_Pre,Mode_Pre)
%% ����
%Velocity_Pre ���ٷ���ǰ������
%SwitchPoint_Pre ���ٷ���ǰ�Ĺ���ת����
%Mode_Pre: ATP�������ߵ�ÿ��λ����ɢ������ʹ�õĹ���
%|�������� |�����
%0-��Ч���� 1-ǣ�� 2-���� 3-���� 4-�ƶ�
%% ���
% Velocity_After ���ٷ�������ٶ�����
% SwitchPoint_After ���ٷ�����ĸſ�ת����

%Mode_After: ATP�������ߵ�ÿ��λ����ɢ������ʹ�õĹ���
%|�������� |�����
%0-��Ч���� 1-ǣ�� 2-���� 3-���� 4-�ƶ�

%% global
global MaxCapacityV;%ATP����
global ATP_Mode;%ATP���߶�Ӧ�Ĺ�����ɢ����
global direction;
global T;%����ʱ��Լ������λ��
global epsi_t; %ʱ��Լ�������
global Dis_Space;% 1:N+1
%%
[~, len_Velocity_Pre]=size(Velocity_Pre);
Mode_After=Mode_Pre;
Velocity_After=Velocity_Pre;
f_safe=0;
for i=2:1:len_Velocity_Pre-1
    if Velocity_Pre(1,i)>MaxCapacityV(1,i)      
        Velocity_After(1,i)=MaxCapacityV(1,i);
%         disp('i= ')
%         disp(i)
%         disp('pos(i= )')
%         disp(Dis_Space(1,i))
%         disp('Velocity_Pre(1,i)=')
%         disp(Velocity_Pre(1,i))
%         disp('MaxCapacityV(1,i)=')
%         disp(MaxCapacityV(1,i))
        f_safe=f_safe+1;
        Mode_After(i-1,1)=ATP_Mode(i-1,1);
    end
end
[len_Mode_After,~]=size(Mode_After);

%|�л�λ�� | �������� |�����л�λ������|�����л�λ������
%�л�λ�ã���λm
%�������ͣ�0-��Ч���� 1-ǣ�� 2-���� 3-���� 4-�ƶ�
SwitchPoint_Pre=[zeros(len_Mode_After,1) zeros(len_Mode_After,1) zeros(len_Mode_After,1) zeros(len_Mode_After,1)];

SwitchPoint_Pre(1,1)=Mode_After(1,2);
SwitchPoint_Pre(1,2)=Mode_After(1,1);
SwitchPoint_Pre(1,3)=Mode_After(1,2);
SwitchPoint_Pre(1,4)=Mode_After(1,2);
flag=1;

for i=1:1:len_Mode_After-1
    if (Mode_After(i,1)==4 && Mode_After(i+1,1)~=4)
        flag=flag+1;
        SwitchPoint_Pre(flag,1)=Mode_After(i,2);%�л�λ��
        SwitchPoint_Pre(flag,2)=Mode_After(i,1);%��������
        SwitchPoint_Pre(flag,3)=SwitchPoint_Pre(flag-1,1);%λ������
    end
    if ((Mode_After(i,1)~=Mode_After(i+1,1) && Mode_After(i+1,1)~=4) || i==len_Mode_After-1)
        flag=flag+1;
        SwitchPoint_Pre(flag,1)=Mode_After(i+1,2);%�л�λ��
        SwitchPoint_Pre(flag,2)=Mode_After(i+1,1);%��������
        SwitchPoint_Pre(flag,3)=SwitchPoint_Pre(flag-1,1);%λ������
    end
end
SwitchPoint_After=[zeros(flag,1) zeros(flag,1) zeros(flag,1) zeros(flag,1)];    
for i=1:1:flag
    SwitchPoint_After(i,1)=SwitchPoint_Pre(i,1);
    SwitchPoint_After(i,2)=SwitchPoint_Pre(i,2);
    SwitchPoint_After(i,3)=SwitchPoint_Pre(i,3);
    SwitchPoint_After(i,4)=SwitchPoint_Pre(i+1,1);
end
SwitchPoint_After(flag,3)=SwitchPoint_After(flag,1);
SwitchPoint_After(flag,4)=SwitchPoint_After(flag,1);

%% ͳ������ʱ�䡢�ܺġ�

end