%___________________________________________________________________%
% Guided Adaptive Search-based Particle Swarm Optimizer (GuASPSO)   %
%                                                                   %
% Developed in MATLAB R2018b                                        %
%                                                                   %
% Author and programmer: Farshad Rezaei, PhD                        %
%                                                                   %
% e-Mail: farshad.rezaei@gmail.com                                  %
%         f.rezaei@alumni.iut.ac.ir                                 %
%                                                                   %
% Homepage: https://www.linkedin.com/in/farshad-rezaei-5a92559a/    %
%                                                                   %
% Main paper: Rezaei, F., Safavi, H.R., (2020) "GuASPSO: A new      %
% approach to hold a better exploration-exploitation balance in PSO %
% algorithm", Soft Computing, 24: 4855-4875.                        %
%___________________________________________________________________%

% The initial parameters that you need are:
%__________________________________________
% fobj = @YourCostFunction
% nx = number of your variables
% lb= the lower bound of variables which can generally be a fixed number or a vector
% ub= the upper bound of variables which can generally be a fixed number or a vector
% notice: if the lower nad upper bounds are not fixed for all variables, 
% they appear in the forms of the vectors "varmin" and "varmax", as illustrated in following

% To run GuASPSO: [z_iter,z_final,pos_final]=GuASPSO(nrun,np,nx,somit,maxit,varmax,varmin,velmax,velmin,k_max,k_min,fobj,w_mode,lr_max,cluster_max,cluster_min);
%__________________________________________
% Set the required parameters to run the GuASPSO algorithm

% This code is for solving the minimization problems. To maximize a desired 
% cost function,please implement this code upon inverting the cost function

clc
clear
close all
tic
run=1; % Maximum number of the algorithm runnings conducted
np=50; % Number of search agents
Function_name='F1'; % Name of the test function that can be from F1 to F23 (Table 1,2,3 in the paper)
somit=4*np; % Maximum number of SOM iterations
maxit=1000; % Maximum number of iterations
k_max=0.9; % Upper bound of the inertia weight
k_min=0.4; % Lower bound of the inertia weight
w_mode=2; % w_mode=1; if decided to define inverted density-based weight for the Cbests & w_mode=2; if no weight is considered
lr_max=0.1; % Maximum learning rate defined for clustering by SOM
cluster_max=np; % Maximum number of clusters, considered at the first iteration
cluster_min=2; % Minimum number of clusters, considered at the last iteration
[lb,ub,nx,fobj]=Objective_Function(Function_name); % Load details of the selected benchmark function
varmax=ub*ones(1,nx); % Upper bound defined for the positions which can generally be a desired vector
varmin=lb*ones(1,nx); % Lower bound defined for the positions which can generally be a desired vector
limvel=0.1; % A ratio of the maximum distance in the search space to form the maximum velocity 
velmax=limvel*(varmax(1,1:nx)-varmin(1,1:nx)); % Upper bound defined for the velocities
velmin=-velmax; % Lower bound defined for the velocities
z_iter_main=zeros(run,maxit);
z_final_main=zeros(run);
pos_final_main=zeros(run,nx);
x1=zeros(maxit);
y1=zeros(maxit);

% Run the GuASPSO algorithm for "run" times 
for nrun=1:run
    [z_iter,z_final,pos_final]=GuASPSO(np,nx,somit,maxit,varmax,varmin,velmax,velmin,k_max,k_min,fobj,w_mode,lr_max,cluster_max,cluster_min);
     z_iter_main(nrun,1:maxit)=z_iter(1:maxit);
     z_final_main(nrun)=z_final;
     pos_final_main(nrun,1:nx)=pos_final(1:nx);
%      disp(['The best objective function value obtained by GuASPSO = ',num2str(z_final_main(nrun))]);
%      disp(['The best solution obtained by GuASPSO = ','[',num2str(pos_final_main(nrun,1:nx)),']']);
end

% Display the comprehensive results
disp(['The final statistical results calculated when implementing the GuASPSO algorithm for ',num2str(run),' times are as follows:']);
disp(['The average of the final objective function values calculated over ',num2str(run),' times = ',num2str(mean(z_final_main(1:run)))]);
disp(['The median of the final objective function values calculated over ',num2str(run),' times = ',num2str(median(z_final_main(1:run)))]);
disp(['The best of the final objective function values calculated over ',num2str(run),' times = ',num2str(min(z_final_main(1:run)))]);
disp(['The standard deviation of the final objective function values calculated over ',num2str(run),' times = ',num2str(std(z_final_main(1:run)))]);

% Draw the chart of the objective function values obtained by GuASPSO over the course of iterations
for i=1:maxit
    x1(i)=i;sum1=0;
    for j=1:run
        sum1=sum1+z_iter_main(j,i);
    end
    y1(i)=sum1/run;
end
semilogy(x1,y1,'-r')
xlabel('Iteration');
ylabel('Average best-so-far');
legend('GuASPSO');
hold on
time_guaspso = toc;
disp(['Elapsed time of running the GuASPSO for ',num2str(run),' times = ',num2str(time_guaspso),' seconds']);