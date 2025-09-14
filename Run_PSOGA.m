clc;
Global;
global fitness_stop;
global SpdLimit;
global Dis_Space;% 1:N+1
global MaxCapacityV;%1:N+1
global ATP_Mode;%1:N+1
global Population_Size_PSO;


[Population_G]=InitPopulationForPSO();
[row_P,col_P]=size(Population_G{1,1});
iteration=1;
BestParticle_Individual={};
BestFitness_Individual={};
BestParticle_Global={};
BestFitness_Global={};
BestFitness_Global{1,1}=1e16;
[AllInitVelocity]=cellfun(@InitVelocity,Population_G,'un',0);

 while 1
    tic
    disp('����')
    disp(iteration)
    disp('���㱾����Ⱥ��Ӧ��')
    [Ranked_Fitness,Ranked_Population,AllFitness,Population]=AllFitnessCalc(Population_G);
    disp('�������Ÿ�����Ӧ��= ')
    disp(Ranked_Fitness{1,1}(1,1))
    
    %ÿ�����Ӿ���������ʷ��õ�
    if isempty(BestParticle_Individual)
    BestParticle_Individual=Population;
    BestFitness_Individual=AllFitness;
    else   
        for j=1:1:Population_Size_PSO
            if AllFitness{1,j}(1,1)<BestFitness_Individual{1,j}(1,1)
                BestParticle_Individual{1,j}=Population{1,j};
            end
        end
    end
    
    %Ⱥ����������������������õĵ�
    disp('������ʷ��������')
    if Ranked_Fitness{1,1}<=BestFitness_Global{1,1}
    BestParticle_Global{1,1}=Ranked_Population{1,1};
    BestFitness_Global{1,1}=Ranked_Fitness{1,1};
    end
    disp('��ʷ����������Ӧ��')  
    disp(BestFitness_Global{1,1}(1,1))
    toc;
    disp(' ')
    
    if (BestParticle_Global{1,1}(1,1)<fitness_stop+6 && iteration>50)||(BestParticle_Global{1,1}(1,1)<fitness_stop+4)
        break;
    end
    
    iteration_M=(iteration-1)*ones(1,Population_Size_PSO);
    iteration_Cell=num2cell(iteration_M);
    BestParticle_Global_Col= BestParticle_Global{1,1}(:,1);
    BestParticle_Global_M=zeros(row_P,Population_Size_PSO);
    BestParticle_Global_M(:,1:Population_Size_PSO)=repmat(BestParticle_Global_Col(:,1),[1,Population_Size_PSO]);
    BestParticle_Global_Cell=num2cell(BestParticle_Global_M,1);
    [Population_Moved,AllVelocity_After]= cellfun(@UpdatePosition,Population,AllInitVelocity,BestParticle_Individual,BestParticle_Global_Cell,iteration_Cell,'un',0);
    Population_G=Population_Moved;
    iteration=iteration+1;
    AllInitVelocity=AllVelocity_After;
 end
 
disp('�����Ŵ��㷨')
iteration=1;
flag_disaster=0;%�����Ƿ����������֣����ƻ���Ⱥ
BestFitness_History={};
while 1
    tic
    disp('����')
    disp(iteration)
    disp('���㱾����Ⱥ��Ӧ��')
    [Ranked_Fitness,Ranked_Population]=AllFitnessCalc(Population_G);
    disp('�������Ÿ�����Ӧ��= ')
    disp(Ranked_Fitness{1,1}(1,1))
    BestFitness_History{1,iteration}=Ranked_Fitness{1,1}(1,1);
    toc;
    disp(' ')
    
%     % �����ƻ���Ⱥ,���ƻ������Ⱥ����������Ŵ�����
%     if iteration>50 && abs(BestFitness_History{1,iteration}-BestFitness_History{1,iteration-1})<0.1  && flag_disaster==0
%         disp('�����趨��������')
%         flag_disaster=1;
%         [Population_Disaster]=InitPopulation();
%         Population_After_Disaster=Ranked_Population;
%         for z=ceil(Population_Size/2):1:Population_Size-1
%             Population_After_Disaster{1,z}=Population_Disaster{1,z};
%         end
%         Population_G=Population_After_Disaster;
%         [Ranked_Fitness,Ranked_Population]=AllFitnessCalc(Population_G);
%     end
    
    if Ranked_Fitness{1,1}(1,1)<fitness_stop%ͣ��׼��1���ﵽ��Ӧ��Ҫ��
        break;
    else%�Ŵ�����
        [Fitness_Selected,Population_Selected]=Select(Ranked_Fitness,Ranked_Population);
        [Population_Crossed]=Cross(Population_Selected);
        [Population_Mutated]=Mutation(Population_Crossed);
    end
    Population_G=Population_Mutated;
    iteration=iteration+1;
    
    if iteration>=400%ͣ��׼��2���ﵽ��������
        break;
    end     
end
toc;
[Pos,Velocity,Force,Time,Energy,Mode,f_punc]=TractionSolve(Ranked_Population{1,1});
figure(3)
plot(Dis_Space,SpdLimit,'--r','LineWidth',1.5)
hold on
plot(Dis_Space,MaxCapacityV,'-g','LineWidth',1.5)
hold on
plot(Pos,Velocity,'-b','LineWidth',1.5)
hold on
plot(Mode(:,2),Mode(:,1)*10,'--b','LineWidth',1.0)
hold on
plot(ATP_Mode(:,2),ATP_Mode(:,1)*10,'--m','LineWidth',1.0)
set(gca,'xdir','reverse')
legend('����','ATP����','��������','�������߹���','ATP���߹���')
hold off