# Train Speed Profile Optimization Based on GA and PSO

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Language](https://img.shields.io/badge/Language-MATLAB-orange.svg)](https://www.mathworks.com/products/matlab.html)

This repository provides a MATLAB implementation for optimizing train speed profiles to achieve energy-efficient operation. The project leverages Genetic Algorithm (GA), Particle Swarm Optimization (PSO), and two novel hybrid GA-PSO algorithms to find the optimal sequence of control actions (traction, cruising, coasting, and braking).

A key innovation of this project is a heuristic-based dimensionality reduction and encoding strategy. This method intelligently constrains the solution space by analyzing the track gradient, significantly improving the convergence speed and the quality of the final solution.

## Features

- **Four Optimization Algorithms:** Implements standard GA, standard PSO, and two hybrid variants (GA-PSO and PSO-GA) for comprehensive analysis.
- **Novel Heuristic Encoding:** A sophisticated encoding strategy that reduces the problem's dimensionality by dividing the track into logical sub-intervals based on slope characteristics. This ensures a higher proportion of feasible solutions.
- **Detailed Train Dynamics Model:** The `TrainEnvironment` module simulates realistic train movement, considering factors like speed limits, tractive/braking effort curves, running resistance, and gradient effects.
- **Modular and Clear Structure:** The code is organized into distinct modules for algorithms, environment simulation, encoding/decoding, and parameter inputs, making it easy to understand and extend.
- **Visualization of Results:** Automatically generates plots for the optimized speed profile, control regimes, and energy consumption metrics.

## Core Concept: Heuristic-Based Dimensionality Reduction and Encoding

The primary challenge in train speed profile optimization is the vast and continuous search space. To address this, we developed a novel encoding method that reduces dimensionality and embeds expert knowledge into the optimization process.

### 1. Slope Classification

The algorithm first classifies the track profile. The total running resistance of the train, $F_R$, is a function of its position $x$ and velocity $v$:

$F_R = F_s(x) + F_0(v)$

where $F_s(x)$ is the additional resistance from the track gradient and $F_0(v)$ is the basic running resistance. Based on this, track segments are classified as follows:

-   **Steep Downhill:** A segment where the train accelerates even when coasting (i.e., the net force $-F_R > 0$).
-   **Steep Uphill:** A segment where the train decelerates even under maximum traction force $F_T$ (i.e., the net force $F_T - F_R < 0$).
-   **Mild Slope:** All other segments that are not Steep Uphill or Steep Downhill.

### 2. Sub-interval Division

Based on the slope classification, the entire track is divided into a series of logical sub-intervals. The division rule is:

-   A sub-interval begins at the start of a **Steep Uphill** or **Mild Slope**.
-   It ends at the termination point of the first **Steep Downhill** encountered after its start.
-   **Edge cases** are handled by adding zero-length dummy segments to ensure the logic is consistent at the route's start and end points.

This division transforms a complex track profile into a structured sequence of manageable optimization problems.

### 3. Predefined Operating Sequence

Within each sub-interval, we enforce a logical sequence of operating conditions to further constrain the search and eliminate infeasible solutions:

`{Maximum Traction -> Cruising -> Coasting -> (Necessary) Braking}`

The optimization algorithm's task is not to decide the *sequence* but to find the optimal *locations* for switching between these states.

-   The switch to **Cruising** from Maximum Traction at position $x_1$ must occur after the sub-interval start ($x_{a0}$) and before the start of the Steep Downhill segment ($x_{a1}$), i.e., $x_1 \in (x_{a0}, x_{a1}]$.
-   The switch to **Coasting** from Cruising at position $x_2$ must occur after the switch to Cruising ($x_1$) and before the end of the sub-interval ($x_{a2}$), i.e., $x_2 \in (x_1, x_{a2}]$.
-   Braking is applied automatically by the decoder when needed to respect speed limits or stop at the target station.

### 4. Encoding Method

We use **real-number encoding**. Each chromosome represents a complete operating strategy for the entire journey.

-   **Gene:** A gene is a floating-point number representing the *position* ($x_i$) of a switch point between operating conditions (e.g., the position where the train switches from traction to cruising).
-   **Chromosome:** A chromosome is an ordered array of all such switch point positions.

![Chromosome Structure](image.png)

Since the number of sub-intervals and the number of switch points within each sub-interval are fixed by our heuristic rules, the chromosome length ($l$) is constant. This fixed-length, real-encoded structure is ideal for both GA and PSO.

## Project Structure
.
������ Decoder/
�� ������ TractionSolve.m # Decodes a chromosome into a full train trajectory
������ Dimensionality_Reduction/
�� ������ ... # Core functions for slope analysis and sub-interval division
������ Encoder/
�� ������ ... # Functions for fitness evaluation and population sorting
������ GA/
�� ������ ... # Core Genetic Algorithm operators (selection, crossover, mutation)
������ OptimizationOutputs/
�� ������ ... # Default directory for saving plots and results
������ PSO/
�� ������ ... # Core Particle Swarm Optimization operators
������ TrainEnvironment/
�� ������ ... # Train dynamics model, ATP protection, resistance calculations
������ ProjectInput_LineParameters.m # Input file for track data (gradients, speed limits, etc.)
������ Run_GA.m # Main script to run the GA-based optimization
������ Run_PSO.m # Main script to run the PSO-based optimization
������ Run_GAPSO.m # Main script for GA (exploration) + PSO (exploitation) hybrid
������ Run_PSOGA.m # Main script for PSO (exploration) + GA (exploitation) hybrid

## Getting Started

### Prerequisites

-   MATLAB (tested on R2020a or newer)

### How to Run

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/Train_Speed_Profile_Optimization_Based_on_GA-PSO.git
    cd Train_Speed_Profile_Optimization_Based_on_GA-PSO
    ```
2.  **Configure Parameters:**
    Open `ProjectInput_LineParameters.m` in MATLAB to set the line parameters, such as track length, gradients, speed limits, and station locations.

3.  **Run an Optimization:**
    Execute one of the main scripts in the MATLAB command window or editor:

    -   To run the **Genetic Algorithm**:
        ```matlab
        Run_GA
        ```
    -   To run the **Particle Swarm Optimization**:
        ```matlab
        Run_PSO
        ```
    -   To run the **GA-PSO Hybrid Algorithm**:
        ```matlab
        Run_GAPSO
        ```
    -   To run the **PSO-GA Hybrid Algorithm**:
        ```matlab
        Run_PSOGA
        ```
4.  **View Results:**
    Upon completion, the script will generate and save plots of the optimized speed profile, control regimes, and performance metrics in the `OptimizationOutputs` folder.

## Algorithms Implemented

This project provides four distinct optimization algorithms:

1.  **`Run_GA` (Genetic Algorithm):** A classic evolutionary algorithm that uses selection, crossover, and mutation to evolve a population of solutions.
2.  **`Run_PSO` (Particle Swarm Optimization):** A swarm intelligence algorithm where particles move through the solution space based on their own best-known position and the entire swarm's best-known position.
3.  **`Run_GAPSO` (GA-PSO Hybrid):** A hybrid method where GA is used for global search (**exploration**) to identify promising regions of the solution space. The best individuals from the GA are then used to initialize a PSO swarm, which performs a refined local search (**exploitation**).
4.  **`Run_PSOGA` (PSO-GA Hybrid):** An alternative hybrid method where PSO is used for initial global exploration. Genetic operators (crossover and mutation) are then applied to the swarm to enhance diversity and escape local optima, giving GA the role of exploitation and diversity maintenance.

## Contributing

Contributions are welcome! If you have suggestions for improvements or want to add new features (e.g., different optimization algorithms, more complex train models), please feel free to fork the repository and submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details.

## Citation
If you use this code in your research, please consider citing this repository:
@software{YourName_2023_TrainSpeedProfile,
author = {Your Name},
title = {{Train_Speed_Profile_Opimization_Based_on_GA-PSO}},
year = {2023},
publisher = {GitHub},
journal = {GitHub repository},
howpublished = {\url{https://github.com/your-username/Train_Speed_Profile_Optimization_Based_on_GA-PSO}},
}

1.��Ŀ��ʹ�ý���
1.1 ���ļ���Run_GA, Run_PSO, Run_GAPSO, Run_PSOGA�⼸���ļ���ֱ����matlab�����������⼴�����С��»��ߺ�����ݴ����˵����˲�ͬ���㷨��GA��ʾʹ���Ŵ��㷨�����Ż���PSO��ʾʹ������Ⱥ�Ż��㷨�����Ż���GAPSO��ʾʹ���Ŵ��㷨������Ⱥ�Ż��㷨����Ż�������GA����exploration��PSO����exploitation��PSOGA��ʾʹ������Ⱥ�Ż��㷨���Ŵ��㷨����Ż������з�����PSO����exploration��GA����exploitation��
1.2 Decoder�ļ����µ�TractionSolve������ʽ�㷨��decoder����,��������ʽ�㷨ͨ��encodingȻ���Ż�֮��Ľ��decodeΪλ�á��ٶȡ���������ʱ�䡢�ܺġ�����������
1.3 TrainEnviroment�ǻ����������������١��г����ǣ�����������������г������������������ٶ��ƶ�����·���������ļ��㺯���Լ�����������ߺ�����ATP�����������Լ�����ദ�����Լ��г�״̬��������
1.4 Encoder�ļ����²����Ǵ��������ϵ�encoder���������������Ϊ�ı����߼�ͬ��ʹ��TractionSolve���н���Ȼ��������֮�������Ӧ�ȼ���Ͷ���������Ӧ�Ƚ����������Ի��仰˵TractionSolve����encoder����decoder
1.5 GA���Ŵ��㷨���Ĳ���������������ʼ����Ⱥ��ѡ�񡢽���ͱ���
1.6 PSO������Ⱥ�Ż����Ĳ���������������ʼ����Ⱥ����ʼ���ٶȡ���������λ�ú��ٶ�
1.7 PorjectInput_LineParameters����·�����ļ���������·���ߡ���·���١���·�¶Ⱥͳ�վλ��
1.8 OptimizationOutputs�Ƿ����������ļ������λ�á��ٶȡ���������ʱ�䡢�ܺġ����������е�plot����
1.9 Dimensionality_Reduction���㷨�����ļ�����ҪĿ��Ϊ���ͽ�ռ��ά�ȣ�������ǿ����ʽ�㷨�ڴ����г��ٶ������Ż�����ʱ������Ŀ����ԡ�������·�µ����ֺ�������·�����仮�ֺ����ͳ�ʼ���������Լ�

2. ��Ŀ���ͽ�ռ��ά��˼����ܣ�Ҳ������˼·���ܣ�
2.1 �¶��ж�
�г�����ʱ,��ͬλ����������·���治ͬ���ڲ����Ŵ��㷨����г����Ų�������ʱ,���������������������������г�����ת�������������Ĳ����н�,�����������󲻵����н⡣����,���г����¶Ⱥܴ�����µ�������ʱ,������ö��л����ƶ�����,���г��ٶȻἱ���½�,���ܻᵼ���м�ͣ���ȡ�Ϊʹ�Ŵ��㷨�ܹ������Ϻõĳ�ʼ��,����㷨���Ч��,���Ľ��г��������䰴�µ���С���ֳɲ�ͬ��������,����ԭ�����¡������г���ƽ���ٶ�v����,�г���������FR����ʽ(3-1)��ʾ��ϵ��
F_R=F_s(x)+F_0(v)
���г����ö��й���ʱ,��-FR>0,�г���������,����г���ǰ�����µ�Ϊ�����µ�;
���г������������ǣ��ʱ,��F_T-FR<0,�г���������,����г���ǰ�����µ�Ϊ�����µ�;
�������µ��ʹ����µ�֮����µ���Ϊ�����µ���

2.2 �����仮��
�������������г��������仮��Ϊ����������,һ���������Դ����µ��������µ�Ϊ���,�м���ܻᾭ�����ɸ������µ�������µ�,ֱ�����������µ�,���Դ����µ���ĩ��Ϊ�յ㡣����,���г��𳵵㴦Ϊ�����µ�,�����г��𳵵㴦��Ϊ���һ�γ���Ϊ0�������µ�,���𳵵㴦�Ĵ����µ���ͬ����һ��������;���г�ͣ���㴦Ϊ�����µ��������µ�,�����г�ͣ���㴦��Ϊ���һ�γ���Ϊ0�Ĵ����µ�,��ͣ���㴦�Ĵ����µ��������µ���ͬ����һ�������䡣

2.3 ��ʼ��������
�г���һ���������ڵĲ��ݹ�������Ϊ{ȫ��ǣ��,����,���м���Ҫ���ƶ�}�������������x_a0������ȫ��ǣ������ת����;���ٹ���ת������ǰһ��ȫ��ǣ������ת���㵽���������ڴ�������ʼ�㷶Χ�ڲ���,��x��(x_a0,x_a1],;������ٹ���ת������ͼ��x_1��,����й���ת������ǰһ�����ٹ���ת���㵽���������յ㷶Χ�ڲ���,��$x��(x_1,x_a2]$,��2��ʾ;�����������ٻ���Ҫ�ƶ�����ʱ����ȫ���ƶ�������

2.4 ���뷽��
����Ŀ�о����������г������Ż�,����г��ڸ����������������ʱ�������µ����Ų������С���Щ����������һϵ�еĹ���ת����(x_i,S_oci)���,����x_iΪ����ת�����λ��,S_ociΪ��Ӧλ�õĹ��������,���Խ�ÿһ������ת������Ϊ����,������������W��Ϊһ��Ⱦɫ�塣Ⱦɫ��Ϊ���չ���ת����λ�����е��������С����ڹ���ת�����λ��x_i�������仯��ʵ��,����Ϊ��ɢ�ļ���,�ʱ��Ĳ���ʵ�����뷽ʽ���б��롣�����µ����ַ������г��������仮��Ϊ���������,�����ݳ�ʼ��������ԭ��,�����������ת����λ��x_i,����Ⱦɫ�塣Ⱦɫ�幹������ͼ��ʾ,����lΪȾɫ�峤�ȡ������г���������̶�,ÿ���������ڹ���ת���������̶�,��Ⱦɫ�峤�ȹ̶�,��lΪ��ֵ��

![alt text](image.png)



