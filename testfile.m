%% Generate Topology  === OUTPUT ONLY THE LINKS ===

xMax              = 100;
yMax              = 100;

num_points        = 200;
num_clusters      = 80;
max_link_dist     = 20; %km
max_incls_dist     = 0.1; %km

generate_topology_wGUI2(xMax, yMax, num_points, num_clusters, max_link_dist, max_incls_dist);

%%
%load data: links

load("topology_data.mat");

%Define the Inputs = f, P, T
Input.f=7000; %%frequency input - fixed as the smallest
Input.P=30; %Transmit power = 1W or 2W
Input.T=-79.12;
%T=-120;

%Define the topology = Coord
N_link=size(links,1);
%N_link=25;

Coord.x_coord_src=zeros(1,N_link);Coord.y_coord_src=zeros(1,N_link);
Coord.x_coord_vtm=zeros(1,N_link);Coord.y_coord_vtm=zeros(1,N_link);

%step_dist=8;
N_freq=7000;

for ii=1:N_link
    Coord.y_coord_src(ii)=links(ii,1);
    Coord.x_coord_src(ii)=links(ii,2);
    Coord.y_coord_vtm(ii)=links(ii,3);
    Coord.x_coord_vtm(ii)=links(ii,4);
end

%Calculate EIL
WE=EIL_dumb(Input,Coord);

%%
%Frequency Assignment Algorithm

%Greedy
% curr_assignment = zeros(1,N_link);
% ret_Greedy_assignment=Freq_Assign_Greedy(WE,curr_assignment);
% [R_greedy ,af_greedy ] = measure(ret_Greedy_assignment);

%COG
curr_assignment = zeros(1,N_link);
ret_COG_assignment=Freq_Assign_ColorBased(WE,curr_assignment,0);
[R_COG ,af_COG ] = measure(ret_COG_assignment);

%HEDGE
curr_assignment = zeros(1,N_link);
ret_HEDGE_assignment = Freq_Assign_Greedy(WE,curr_assignment);
[R_HEDGE ,af_HEDGE ] = measure(ret_HEDGE_assignment);

%Hybrid
curr_assignment = zeros(1,N_link);
num_color_based = 10;
ret_Hybrid_assignment = Freq_Assign_Hybrid(WE,curr_assignment,num_color_based);
[R_Hybrid ,af_Hybrid ] = measure(ret_Hybrid_assignment);

%%
%variate Hybrid num_color_based 
curr_assignment = zeros(1,N_link);
num_color_based = 5;
ret_Hybrid5_assignment = Freq_Assign_Hybrid(WE,curr_assignment,num_color_based);
[R_Hybrid5 ,af_Hybrid5 ] = measure(ret_Hybrid5_assignment);

curr_assignment = zeros(1,N_link);
num_color_based = 20;
ret_Hybrid20_assignment = Freq_Assign_Hybrid(WE,curr_assignment,num_color_based);
[R_Hybrid20 ,af_Hybrid20 ] = measure(ret_Hybrid20_assignment);

curr_assignment = zeros(1,N_link);
num_color_based = 50;
ret_Hybrid50_assignment = Freq_Assign_Hybrid(WE,curr_assignment,num_color_based);
[R_Hybrid50 ,af_Hybrid50 ] = measure(ret_Hybrid50_assignment);

curr_assignment = zeros(1,N_link);
num_color_based = 100;
ret_Hybrid100_assignment = Freq_Assign_Hybrid(WE,curr_assignment,num_color_based);
[R_Hybrid100 ,af_Hybrid100 ] = measure(ret_Hybrid100_assignment);

%%
