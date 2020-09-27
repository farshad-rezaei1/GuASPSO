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

% This function enables the SOM neural network to do clustering process
function [pp_gbest] = SOM(ncluster,pp_pbest,z_pbest,lr_max,somit,w_mode,np,nx,varmax,varmin) 
win_neuron=zeros(np);
pp_cbest=zeros(ncluster,nx);
neuron=zeros(ncluster,nx);
weight=zeros(ncluster);
weight_norm=zeros(ncluster);
pp_gbest=zeros(np,nx);

% Initializing the lattice of the neurons
for j=1:ncluster
    neuron(j,1:nx)=(varmax(1,1:nx)-varmin(1,1:nx)).*rand(1,nx)+varmin(1,1:nx);
end

% Finding out the best-matching neuron for each Pbest particle
for itt=1:somit
    jj=mod(itt,np);
    if jj==0
        jj=np;
    end
    min_norm=inf;
    for j=1:ncluster
        if norm(pp_pbest(jj,:)-neuron(j,:))<min_norm
            min_norm=norm(pp_pbest(jj,:)-neuron(j,:));
            win_neuron(jj)=j;
        end
    end
    tt=win_neuron(jj);
    learn_rate=lr_max*exp(-itt/somit); % Eq. (10)
    if tt==1 && tt==ncluster
        t1=tt;
        t2=tt;
        t3=tt;
    elseif tt==1 && tt~=ncluster
        t1=tt;
        t2=tt+1;
        t3=ncluster;
    elseif tt==ncluster && tt~=1
        t1=tt;
        t2=1;
        t3=tt-1;
    else 
        t1=tt;
        t2=tt+1;
        t3=tt-1;
    end
    
    % Update the winning neuron and its two nearest neighbors
    neuron(t1,:)=neuron(t1,:)+learn_rate*(pp_pbest(jj,:)-neuron(t1,:)); % Eq. (9)
    neuron(t2,:)=neuron(t2,:)+learn_rate*(pp_pbest(jj,:)-neuron(t2,:)); % Eq. (9)
    neuron(t3,:)=neuron(t3,:)+learn_rate*(pp_pbest(jj,:)-neuron(t3,:)); % Eq. (9)
end

% Determine the cluster of each Pbest particle and the best (Cbest) particle of each cluster
rr=zeros(ncluster);
z_cbest=inf*ones(ncluster);
for jj=1:np
    min_norm=inf;
    for j=1:ncluster
        if norm(pp_pbest(jj,:)-neuron(j,:))<min_norm
            min_norm = norm(pp_pbest(jj,:)-neuron(j,:));
            win_neuron(jj) = j;
        end
    end
    i=win_neuron(jj);
    rr(i)=rr(i)+1;
    if rr(i)>=1
        if z_pbest(jj)<z_cbest(i)
            z_cbest(i)=z_pbest(jj);
            pp_cbest(i,1:nx)=pp_pbest(jj,:);
        end
    end
end

% Give weight to the clusters depending on the method employed to do so- Eq. (12)
sum1=0;
for jj=1:ncluster
    if rr(jj)>=1
        if w_mode==1
            weight(jj)=1/rr(jj);
        elseif w_mode==2
            weight(jj) = 1;
        end
        sum1=sum1+weight(jj);
    end
end

% Take the weighted average of the opposite Cbests to calculate the unique Gbests- Eq. (13)
for j=1:np
    i=win_neuron(j);
    if ncluster == 1
        pp_gbest(j,1:nx) = pp_cbest(i,1:nx);
    else
        dimn=zeros(nx);
        for ii=1:ncluster
            if ii~=i && rr(ii)>=1
                weight_norm(ii)=weight(ii)/(sum1-weight(i));
                dimn(1:nx)=dimn(1:nx)+weight_norm(ii)*pp_cbest(ii,1:nx);
            end
        end
        pp_gbest(j,1:nx)=dimn(1:nx);
    end
end
end