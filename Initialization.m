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

% This function is to initialize the position and velocity of the particles to start the optimization process
function [pp,pv] = Initialization(np,nx,varmax,varmin,velmax,velmin)
pp=zeros(np,nx);
pv=zeros(np,nx);

for j=1:np
    pp(j,1:nx)=(varmax-varmin).*rand(1,nx)+varmin;
    pv(j,1:nx)=(velmax-velmin).*rand(1,nx)+velmin;
end
end

