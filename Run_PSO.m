
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
    disp('代数')
    disp(iteration)
    disp('计算本代种群适应度')
    [Ranked_Fitness,Ranked_Population,AllFitness,Population]=AllFitnessCalc(Population_G);
    disp('本代最优个体适应度= ')
    disp(Ranked_Fitness{1,1}(1,1))
    
    %每个粒子经历过的历史最好点
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
    
    %群体内所有粒子所经过的最好的点
    disp('更新历史最优粒子')
    [row_Ranked_Population,~]=size(Ranked_Population{1,1});
    if Ranked_Fitness{1,1}<=BestFitness_Global{1,1} && row_Ranked_Population==row_P
    BestParticle_Global{1,1}=Ranked_Population{1,1};
    BestFitness_Global{1,1}=Ranked_Fitness{1,1};
    end
    disp('历史最优粒子适应度')  
    disp(BestFitness_Global{1,1}(1,1))
    toc;
    disp(' ')
    
    if BestFitness_Global{1,1}(1,1)<fitness_stop
        break;
    else
        iteration_M=(iteration-1)*ones(1,Population_Size_PSO);
        iteration_Cell=num2cell(iteration_M);
        BestParticle_Global_Col= BestParticle_Global{1,1}(:,1);     
        BestParticle_Global_M=zeros(row_P,Population_Size_PSO);      
        BestParticle_Global_M(:,1:Population_Size_PSO)=repmat(BestParticle_Global_Col(:,1),[1,Population_Size_PSO]);
        BestParticle_Global_Cell=num2cell(BestParticle_Global_M,1);
        [Population_Moved,AllVelocity_After]= cellfun(@UpdatePosition,Population,AllInitVelocity,BestParticle_Individual,BestParticle_Global_Cell,iteration_Cell,'un',0);
        Population_G=Population_Moved;
    end
    iteration=iteration+1;
    AllInitVelocity=AllVelocity_After;
    if iteration>=300%停机准则2：达到迭代上限
        break;
    end
 end
  

 