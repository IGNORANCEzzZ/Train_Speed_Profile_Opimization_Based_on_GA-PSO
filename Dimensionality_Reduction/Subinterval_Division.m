function [Subinterval]=Subinterval_Division()

 %|����� |�µ�ǧ���� |�µ�����
global gradient_after_judge;%�����յ�֮����µ�

%|�µ����| �µ�ǧ����| �µ��յ�| �µ�����
global Gradient_After_Judge;%������·���µ�

global start_pos;%��ʼ��λ�ã���λm
global end_pos;%������λ�ã���λm
global IsStop;
global Station;
global step_s;
 
[row_staion,~]=size(Station);
num_of_allGradient=length(Gradient_After_Judge);
%|���������| �������յ�| ���������Ƿ��г�������-1��ʾ��-0��ʾû��| �������µ����| ���������Ƿ���Ҫ�ƶ�ͣ��-1��ʾ��Ҫ-0��ʾ����Ҫ | �������Ƿ��Ǵӳ�վ��-1��ʾ��Ҫ-0��ʾ����Ҫ
Subinterval_before=[zeros(num_of_allGradient,1) zeros(num_of_allGradient,1) zeros(num_of_allGradient,1) zeros(num_of_allGradient,1) zeros(num_of_allGradient,1) zeros(num_of_allGradient,1)];

length_of_gradient=length(gradient_after_judge);
num_of_subinterval=0;

Subinterval_before(1,1)=start_pos;
for i=1:1:length_of_gradient-1
    if gradient_after_judge(i,3)==3 && gradient_after_judge(i+1,3)~=3
        num_of_subinterval=num_of_subinterval+1;
        Subinterval_before(num_of_subinterval,2)=gradient_after_judge(i,1);%�������յ�
        Subinterval_before(num_of_subinterval,3)=1;%���������д����µ�
        for j=i:-1:2
            if gradient_after_judge(j,3)==3 && gradient_after_judge(j-1,3)~=3
               break; 
            end
        end
        Subinterval_before(num_of_subinterval,4)=gradient_after_judge(j-1,1);%�����µ����
        Subinterval_before(num_of_subinterval+1,1)=gradient_after_judge(i,1);%�¸����������
    end
    if IsStop %����м䳵վ��Ҫͣ������ô��Ҫ���м䳵վҲ��Ϊ�ϸ���������յ���¸�����������
        for z=1:1:row_staion
            if (gradient_after_judge(i,1)==Station(z,1))||(gradient_after_judge(i,1)<Station(z,1) && gradient_after_judge(i,1)+step_s>Station(z,1))
                num_of_subinterval=num_of_subinterval+1;
                Subinterval_before(num_of_subinterval,2)=Station(z,1);%�������յ�
                Subinterval_before(num_of_subinterval,5)=1;%����������Ҫͣ���ƶ����������յ�
                Subinterval_before(num_of_subinterval+1,1)=Station(z,1);%�¸����������
            end
        end
    end
end
Subinterval_before(num_of_subinterval+1,2)=end_pos;%���һ��������
Subinterval_before(num_of_subinterval+1,5)=1;%���һ����������Ҫͣ���ƶ�

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