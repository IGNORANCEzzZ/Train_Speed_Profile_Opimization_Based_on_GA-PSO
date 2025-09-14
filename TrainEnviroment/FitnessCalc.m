function [fitness]=FitnessCalc(Energy,f_safe,f_punc)
global Penalty_coefficient_safe;
global Penalty_coefficient_punc;
fitness=Energy(1,end)+Penalty_coefficient_safe*f_safe+Penalty_coefficient_punc*abs(f_punc);
end