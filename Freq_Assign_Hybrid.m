function [ res_assignment ] = Freq_Assign_Hybrid( WE, curr_assignment, num_color_based )

num_links = size(curr_assignment, 2);

Freq_tmp       = Freq_Assign_ColorBased(WE, curr_assignment, num_links-num_color_based);
res_assignment = Freq_Assign_Greedy(WE, Freq_tmp);

end

