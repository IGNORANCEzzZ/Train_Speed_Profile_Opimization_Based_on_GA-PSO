function [SwitchPoint]=InitSwitchPoint(Subinterval)
%% ���
% SwitchPoint�������л���
%|�л�λ�ã���λm| �������� |�����л�λ������|�����л�λ������|����������1-���� 0-����
%�������ͣ�0-��Ч���� 1-ǣ�� 2-���� 3-���� 4-�ƶ� 5-������
%% ����
%Subinterval:������
%|���������| �������յ�| ���������Ƿ��г������£�1��ʾ�� 0��ʾû��| �������µ����| ���������Ƿ���Ҫ�ƶ�ͣ�� 1��ʾ��Ҫ 0��ʾ����Ҫ| �������Ƿ��Ǵӳ�վ��-1��ʾ��Ҫ-0��ʾ����Ҫ
%%
global step_s;
global start_pos;%��ʼ��λ�ã���λm
global end_pos;%������λ�ã���λm
global Neutral_Section;%������

if end_pos>start_pos
    step=step_s;
    delta_m=1;
else
    step=-step_s;
    delta_m=-1;
end

[num_of_Subinterval,col]=size(Subinterval);
flag=0; %���Ա����м�����Ҫ�ƶ�ͣ����������
for i=1:1:num_of_Subinterval
    if Subinterval(i,5)==1
        flag=flag+1;
    end
end
num_of_SwitchPoint=3*num_of_Subinterval+flag;%һ���������ֻ��Ҫǣ�������١��������ֹ�������Ҫͣ�����������ٶ�һ���ƶ�����

%|�л�λ�� | �������� |�����л�λ������|�����л�λ������| ����������
%�л�λ�ã���λm
%�������ͣ�0-��Ч���� 1-ǣ�� 2-���� 3-���� 4-�ƶ�
SwitchPoint=[zeros(num_of_SwitchPoint,1) zeros(num_of_SwitchPoint,1) zeros(num_of_SwitchPoint,1) zeros(num_of_SwitchPoint,1) ones(num_of_SwitchPoint,1)];

index=0;%����SwitchPoint���鱻����˼���
for i=1:1:num_of_Subinterval
    if Subinterval(i,5)==1%��Ҫ�ƶ�ͣ��������
        %��������
        SwitchPoint(index+1,2)=1;
        SwitchPoint(index+2,2)=2;
        SwitchPoint(index+3,2)=3;
        SwitchPoint(index+4,2)=4;
        
        %�����л��������޺��л�λ��
        %ǣ�������л��㱻�̶�Ϊ���������
        SwitchPoint(index+1,3)=Subinterval(i,1);
        SwitchPoint(index+1,4)=Subinterval(i,1);
        SwitchPoint(index+1,1)=Subinterval(i,1);
        if Subinterval(i,6)==1%���������ǣ���Ǵӳ�վ�𳵣���ô��ǣ������Ӧ�������λ��򣬲��ٲ����Ŵ�����
            SwitchPoint(index+1,5)=0;
        end
        
        %���ٹ���
        SwitchPoint(index+2,3)=SwitchPoint(index+1,1);%����
        if Subinterval(i,3)==1%���������г�������
            SwitchPoint(index+2,4)=Subinterval(i,4);%�����ǳ����������
        else
            SwitchPoint(index+2,4)=Subinterval(i,2);%�������������յ�
        end
        SwitchPoint(index+2,1)=randi([min([SwitchPoint(index+2,3) SwitchPoint(index+2,4)]) max([SwitchPoint(index+2,3) SwitchPoint(index+2,4)])]);%���޺�����֮����������
        
        %���й���
        SwitchPoint(index+3,3)=SwitchPoint(index+2,1);%����
        SwitchPoint(index+3,4)=Subinterval(i,2);%�������������յ�
        SwitchPoint(index+3,1)=randi([min([SwitchPoint(index+3,3) SwitchPoint(index+3,4)]) max([SwitchPoint(index+3,3) SwitchPoint(index+3,4)])]);%���޺�����֮����������
        
        %�ƶ�����-�ƶ��������÷���Ļ��ƣ����Լ�¼���ǹ����յ㣬���������յ�
        %         SwitchPoint(index+4,3)=SwitchPoint(index+3,1);%����
        %         SwitchPoint(index+4,4)=Subinterval(i,2);%�������������յ�
        %         SwitchPoint(index+4,1)=randi([min([SwitchPoint(index+4,3) SwitchPoint(index+4,4)]) max([SwitchPoint(index+4,3) SwitchPoint(index+4,4)])]);%���޺�����֮����������
        SwitchPoint(index+4,3)=Subinterval(i,2);%���������������յ�
        SwitchPoint(index+4,4)=Subinterval(i,2);%�������������յ�
        SwitchPoint(index+4,1)=Subinterval(i,2);%�ƶ������յ����������յ�
        SwitchPoint(index+4,5)=0;%�ƶ�ͣ���������ٲ����Ŵ�����
        index=index+4;
    else
        %��������
        SwitchPoint(index+1,2)=1;
        SwitchPoint(index+2,2)=2;
        SwitchPoint(index+3,2)=3;
        
        %�����л��������޺��л�λ��
        %ǣ�������л��㱻�̶�Ϊ���������
        SwitchPoint(index+1,3)=Subinterval(i,1);
        SwitchPoint(index+1,4)=Subinterval(i,1);
        SwitchPoint(index+1,1)=Subinterval(i,1);
        if Subinterval(i,6)==1%���������ǣ���Ǵӳ�վ�𳵣���ô��ǣ������Ӧ�������λ��򣬲��ٲ����Ŵ�����
            SwitchPoint(index+1,5)=0;
        end
        
        %���ٹ���
        SwitchPoint(index+2,3)=SwitchPoint(index+1,1);%����
        if Subinterval(i,3)==1%���������г�������
            SwitchPoint(index+2,4)=Subinterval(i,4);%�����ǳ����������
        else
            SwitchPoint(index+2,4)=Subinterval(i,2);%�������������յ�
        end
        SwitchPoint(index+2,1)=randi([min([SwitchPoint(index+2,3) SwitchPoint(index+2,4)]) max([SwitchPoint(index+2,3) SwitchPoint(index+2,4)])]);%���޺�����֮����������
        
        %���й���
        SwitchPoint(index+3,3)=SwitchPoint(index+2,1);%����
        SwitchPoint(index+3,4)=Subinterval(i,2);%�������������յ�
        SwitchPoint(index+3,1)=randi([min([SwitchPoint(index+3,3) SwitchPoint(index+3,4)]) max([SwitchPoint(index+3,3) SwitchPoint(index+3,4)])]);%���޺�����֮����������
        
        index=index+3;
    end
end
for i=2:1:num_of_SwitchPoint
    if SwitchPoint(i,2)==1 && SwitchPoint(i-1,2)==4 && SwitchPoint(i,1)==SwitchPoint(i-1,1)
        SwitchPoint(i,1)=SwitchPoint(i,1)+step;
    end
end

%% ���ദ��-�������⣺û������������
if ~isempty(Neutral_Section)
    [row_Neutral_Section,~]=size(Neutral_Section);
    index=1;%�����Ѿ������ĸ�������
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
            elseif SwitchPoint(i+1,1)>Neutral_Section(index,2) && SwitchPoint(i,1)<Neutral_Section(index,1)%�ɹ�������๤�����뵽ԭ����������
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%ԭ����
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,:)=SwitchPoint(i,:);
                
                len1=min(step_s*60,abs(SwitchPoint(i,1)-Neutral_Section(index,1)));
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%ǣ��
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,1)-delta_m*len1;%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=1;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint(i,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=Neutral_Section(index,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%����
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,1)-delta_m*len1*(2/3);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=2;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=Neutral_Section(index,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%����
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,1)-delta_m*len1*(1/3);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=3;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=Neutral_Section(index,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%������
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,1);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=5;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=Neutral_Section(index,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=Neutral_Section(index,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=0;
                
                len2=min(step_s*60,abs(SwitchPoint(i+1,1)-Neutral_Section(index,2)));
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%ǣ��
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,2);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=1;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=Neutral_Section(index,2);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=Neutral_Section(index,2);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=0;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%����
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,2)+delta_m*len2*(1/3);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=2;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=SwitchPoint(i+1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%����
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,2)+delta_m*len2*(2/3);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=3;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=SwitchPoint(i+1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%ԭ����
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,2)+delta_m*len2;%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=SwitchPoint(i,2);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=SwitchPoint(i+1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                index=index+1;
            elseif SwitchPoint(i,1)>=Neutral_Section(index,1) && SwitchPoint(i,1)<=Neutral_Section(index,2)
                
                len1=min(step_s*60,abs(SwitchPoint(i-1,1)-Neutral_Section(index,1)));
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%ǣ��
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,1)-delta_m*len1;%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=1;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint(i-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=Neutral_Section(index,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%����
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,1)-delta_m*len1*(2/3);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=2;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=Neutral_Section(index,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%����
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,1)-delta_m*len1*(1/3);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=3;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=Neutral_Section(index,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%������
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,1);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=5;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=Neutral_Section(index,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=Neutral_Section(index,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=0;
                
                len2=min(step_s*60,abs(SwitchPoint(i+1,1)-Neutral_Section(index,2)));
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%ǣ��
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,2);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=1;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=Neutral_Section(index,2);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=Neutral_Section(index,2);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=0;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%����
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,2)+delta_m*len2*(1/3);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=2;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=SwitchPoint(i+1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%����
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,2)+delta_m*len2*(2/3);%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=3;
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=SwitchPoint(i+1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                
                num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;%ԭ����
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,1)=Neutral_Section(index,2)+delta_m*len2;%
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,2)=SwitchPoint(i,2);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,3)=SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu-1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,4)=SwitchPoint(i+1,1);
                SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,5)=1;
                index=index+1;
            end
        end
    end
    %���һ������
    num_of_SwitchPoint_Neu=num_of_SwitchPoint_Neu+1;
    SwitchPoint_after_Neutral(num_of_SwitchPoint_Neu,:)=SwitchPoint(num_of_SwitchPoint,:);
    
% %     ɾ���ڽ���ͬ����
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