Date: 2022-03-31
Fixed an accuracy issue in the maximum power calculation function during condition transitions.
This version is currently the most complete and accurate.

Date: 2022-04-08
Algorithm Improvement Directions
Adaptive Parameter Strategy
To improve both convergence speed and optimization capability, an adaptive strategy is used:
Different stages of population evolution employ different population sizes (TBD), selection pressure, crossover probability, and mutation probability.
— Reference: "Application of Adaptive Genetic Algorithm in Train Energy Optimization"

Natural Disaster Mechanism
When the population becomes relatively stable during evolution, introduce some random individuals (regardless of fitness? or limited to low-fitness individuals?) to disrupt the population structure, preventing premature convergence to local optima.
— Reference: "Image Segmentation Based on Improved Genetic Algorithm"

Elitism and Local Optima
Investigate whether the elitism strategy may cause the algorithm to fall into local optima.

Simulated Annealing Integration
When the genetic algorithm slows down, introduce a simulated annealing-inspired disturbance to encourage escape from local minima and guide toward the global optimum.
— Reference: "Feature Selection with Improved Genetic Algorithm for Coronary Heart Disease Detection"

Three-Point Exchange Heuristic Crossover
Replace the traditional two-point crossover operator with a three-point heuristic crossover to improve convergence speed and reduce the likelihood of getting trapped in local optima.
— Reference: "Improved Genetic Algorithm for AGV Path Planning"
(TBD: Practical effect needs to be verified.)

Chaos-Induced Mutation Strategy
Use chaotic search mechanisms to introduce randomness and ergodicity, solving the premature convergence issue:

Add chaotic disturbance to the selection operator
Apply adaptive adjustment for crossover and mutation
Improve the fitness function
— Reference: "Adaptive Genetic Algorithm with Chaotic Micro-Mutation"
Simulated Annealing + Genetic Algorithm for Multi-Task Problems
An improved genetic algorithm combined with simulated annealing is proposed to address problems of slow convergence and local optima in multi-task path planning.
— Reference: "Improved Genetic Algorithm with Simulated Annealing for Multi-Task Path Planning"

Date: 2022-04-25
Updated train characteristics in the global module.
Modified the track line file (likely related to infrastructure/route data).
Updated the GetAddResistance function (possibly related to additional resistance like curves or gradients).
Fixed a time calculation error in the maximum capacity calculation function.





时间：2022.3.31
1.修复了最大能力函数在进行工况转换的时候有不够精准的问题，此版本为目前最完美一版

时间：2022.4.8
算法改进方向：
1.为了同时提高算法的收敛性和寻优能力，采用参数自适应策略，即在种群进化的不同阶段，采用不同的种群规模（？）、选择压力、交叉概率、变异概率
——《自适应遗传算法在列车节能优化中的应用》
2.使用“天灾”设定，即进化过程种群相对稳定时引入一些随机的种群（无论适应度好坏？还是一定是适应度较差的？），以此破坏种群结构,防止算法因为种群内部相对稳定而陷入局部最优解。
——《基于改进遗传算法的图像分割》
3.最优个体保留策略是否会影响算法陷入局部最优
4.当遗传算法进化速度变慢时,采用类模拟退火的方式对遗传算法进行刺激,使遗传算法尽可能地跳出局部最优解的束缚,从而趋向全局最优解（？）
——《基于改进的遗传算法的特征选择方法在冠心病检测中的应用》
5.采用三交换启发交叉算子代替传统的两交换启发交叉算子,防止陷入局部最优并能提高收敛速度。（？）
——《改进遗传算法在AGV路径规划的应用》
6. 利用混沌优化算法具有随机性和遍历性的特点,解决遗传算法容易陷入局部最优解的早熟问题；
同时,对遗传算法的选择算子增加了混沌扰动,对交叉算子和变异算子进行自适应调整,对适应度函数进行改进,使遗传算法整体性能得到提高
——《基于混沌“微变异”自适应遗传算法》
7.针对多任务路径规划存在收敛速度慢、易陷入局部最优解的问题,文中提出一种融合模拟退火准则的改进遗传算法
——《一种融合模拟退火的改进遗传算法多任务路径规划》


时间：2022.4.25
1. 修改了global里的列车特性
2.修改了线路文件
3.修改了GetAddResistance函数
4.最大能力计算函数里的时间计算有问题