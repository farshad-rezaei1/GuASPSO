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

% GuASPSO algorithm                                                                  
function [z_iter,z_final,pos_final] = GuASPSO(np,nx,somit,maxit,varmax,varmin,velmax,velmin,k_max,k_min,fobj,w_mode,lr_max,cluster_max,cluster_min)
it=1;
% disp(['Number of Iterations = ',num2str(it)]);
ncluster=np;
pp_pbest=zeros(np,nx);
optimal_pos = zeros(1,nx);
z_pbest=zeros(np);
z_optimal=inf*ones(maxit);
pos_final=zeros(nx);
z_iter=zeros(maxit);

% Initialization process of the algorithm
[pp,pv]=Initialization(np,nx,varmax,varmin,velmax,velmin);

% Start the optimization process

% Objective function evaluations and determine the personal best solutions and objectives
for j=1:np
    z=fobj(pp(j,1:nx));
    z_pbest(j)=z;
    pp_pbest(j,1:nx)=pp(j,1:nx);
end

% Run the Self-Organizing Map (SOM) neural network to do clustering and calculate the unique Gbests 
[pp_gbest]=SOM(ncluster,pp_pbest,z_pbest,lr_max,somit,w_mode,np,nx,varmax,varmin);

for j=1:np
    if z_pbest(j)<z_optimal(it)
        z_optimal(it)=z_pbest(j);
        optimal_pos(it,:)=pp_pbest(j,:);
    end
end

% Save the best-so-far objective value in the current run
z_iter(it)=z_optimal(it);

% The Main Loop
while it<maxit
    it=it+1;
    ncluster=round(cluster_max-(cluster_max-cluster_min)*(it-1)/(maxit-1)); % Eq. (11)
    k=k_max-(k_max-k_min)*(it-2)/(maxit-2); % Eq. (5)
%     disp(['Number of Iterations = ',num2str(it)]);
    for j = 1:np 
        phi1=2*rand(1,nx);
        phi2=2*rand(1,nx);
        phi=phi1+phi2;
        khi=(2*k)./abs(2-phi-sqrt(phi.*(phi-4))); % Eq. (4)
        
        % Update the velocity of the particles- Eq. (14)
        pv(j,1:nx)=khi.*(pv(j,1:nx)+phi1.*(pp_pbest(j,1:nx)-pp(j,1:nx))+phi2.*(pp_gbest(j,1:nx)-pp(j,1:nx)));
        
        % Return back the velocity of the particles if going beyond the velocity boundaries
        flag4lbv=pv(j,:)<velmin(1,:);
        flag4ubv=pv(j,:)>velmax(1,:);
        pv(j,:)=(pv(j,:)).*(~(flag4lbv+flag4ubv))+velmin.*flag4lbv+velmax.*flag4ubv;
        
        % Update the position of the particles- Eq. (2)
        pp(j,:)=pp(j,:)+pv(j,:);
        
        % Return back the position and velocity of the particles if going beyond the position boundaries
        flag4lbp=pp(j,:)<varmin(1,:);
        flag4ubp=pp(j,:)>varmax(1,:);
        pp(j,:)=(pp(j,:)).*(~(flag4lbp+flag4ubp))+varmin.*flag4lbp+varmax.*flag4ubp; 
        pv(j,:)=(pv(j,:)).*(ones(1,nx)-2*(flag4lbp+flag4ubp)); 
    end
    
    % Objective function evaluations and determining of the personal best solutions and objectives
    for j=1:np
        z=fobj(pp(j,1:nx));
        if z<z_pbest(j)
            z_pbest(j)=z;
            pp_pbest(j,1:nx)=pp(j,1:nx);
        end
    end
    
    % Run the Self-Organizing Map (SOM) neural network to do clustering and calculate the unique Gbests 
    [pp_gbest]=SOM(ncluster,pp_pbest,z_pbest,lr_max,somit,w_mode,np,nx,varmax,varmin);
    
    for j=1:np
        if z_pbest(j)<z_optimal(it)
            z_optimal(it)=z_pbest(j);
            optimal_pos(it,:)=pp_pbest(j,:);
        end
    end
    
    % Save the best-so-far objective value in the current run
    z_iter(it)=z_optimal(it);
end

% Save the final best solution and objective revealed upon the end of the optimization process
z_final=z_optimal(maxit);
pos_final(1:nx)=optimal_pos(maxit,1:nx);
end