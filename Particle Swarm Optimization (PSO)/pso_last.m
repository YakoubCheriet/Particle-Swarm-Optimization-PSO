%% TP IBI : (PSO) Particle Swarm Optimization,
%%% Optimisation par Essaims Particulaires%%%

clc;            % effacer l''ecran,
clear all;      % effacer toutes les valeurs dans le workspace, 
%close all;     % fermer toutes les fenetres precedentes
disp('************************************************');
disp('"""" OPTIMISATION PAR ESSAIMS DE PARTICULES """"');
disp('************************************************');
[popSize,maxIt,nVar]=entree();%Lire les entrées: (max itérations, taille_population, dimensions)

%% Definition du Probleme:
CostFunction = @(x) fitness(x);   % pour ne pas modifier le prg en cas du changement de la fonc [fitness(x)],juste modifier 7 ligne
%nVar = 1;                         % Nombre de Variables  de (decisions) : (("Dimensions")) %1:X, 2:X,Y, 3:X,Y,Z,...
% vecteur de solutions: [1,nVar]
varSize = [1 nVar];               % taile de la matrice, plutot vect de decisions : Solutions!
varMax =  20;                     % bonrne superieur de variables de decision
varMin = -20;                     % bonrne inferieur de variables de decision

%% Parametres du OEP (PSO):
% maxIt = 500;        % nombre maximal d''iterations
% nPop = 20;          % taile de la population (taille d'essaim)
% parametres etant donnes par experimentation:%
w = 1;              % coeffecient d inertia (comme etant donnee dans la v. std. du pso)
wdamp = 0.99;       % damping Ratio of Inertia Coeffecient (Weight)
c1 = 2;             % coefficient d''acceleration personnel
c2 = 2;             % coefficient d''acceleration global

%% Initialisation:
% Template du particule (type structure de données)
empty_particle.Position = [];               %Global P
empty_particle.Velocity = [];               %Global V
empty_particle.Cost = []; %                 %Global C
empty_particle.Best.Position = [];          %Personal Best position du particule
empty_particle.Best.Cost = [];              %Personal Best Cost du particule

% Creation de la population (vecteur)'
particle = repmat(empty_particle, popSize, 1); % repeter_matrice (mat, M, N) 

% initialisation gBest
gBest.Cost = +inf;           % +infinie, la mauvaise valeur pour une minimisation
popSize = 20;                % taile de la population (Swarm Size) 
for i=1:popSize
    % generation de solution aleatoire %
    particle(i).Position = round(unifrnd(varMin, varMax, varSize)); % Arrondi , uniform random (borneInf,borneSup,taille)
    
    % initialisation de velocite
    particle(i).Velocity = zeros(varSize);                 %vect de 0s
    
    % evaluation du particule
    particle(i).Cost = CostFunction(particle(i).Position); % vect de 1 : (X)
    
    % mise a jour du pBest : personal best
    particle(i).Best.Position = particle(i).Position;      %pBest set 2 position courante
    particle(i).Best.Cost = particle(i).Cost;              %pCost set 2 cost courant
    
    % mise a jour du gBest : global best
    if particle(i).Best.Cost < gBest.Cost
        gBest = particle(i).Best; 
        ind=i; 
    end    
end
%ind                 %indice de meilleure valeur
% vect transpose pour obtenir le bestCost a chaque iteration
    bestCosts = zeros(maxIt,1);

%% La Boucle principale du PSO:
for it=1:maxIt
    for i=1:popSize
        % mise a jour de la Velocite
        %Vij(t+1) = w * Vij(t)          % 
        %+ c1*r1(Pij(t)-Xij(t))         %
        %+ c2*r2(Gij(t)-Xij(t))         %
        particle(i).Velocity = w * particle(i).Velocity ...
            + c1*rand(varSize).*(particle(i).Best.Position - particle(i).Position) ...
            + c2*rand(varSize).*(gBest.Position - particle(i).Position);
         % en cas de limites de velocite:
%         particle(i).Velocity = max(particle(i).Velocity, varMin); %prendre la plus grande valeur                  
%         particle(i).Velocity = min(particle(i).Velocity, varMax); %prendre la plus petite valeur
        
        % mise a jour de la Position
        % Xij(t+1) = Xij(t) + Vij(t+1)
        particle(i).Position = particle(i).Position + particle(i).Velocity; 
       
        % attention aux bornes, on ne depasse pas les bornes
        particle(i).Position = max(particle(i).Position, varMin); %prendre la plus grande valeur                  
        particle(i).Position = min(particle(i).Position, varMax); %prendre la plus petite valeur
        
        % evaluation du particule
        particle(i).Cost = CostFunction(particle(i).Position);
        
        % mise a jour du Personal Best
        if particle(i).Cost < particle(i).Best.Cost
            particle(i).Best.Position = particle(i).Position;
            particle(i).Best.Cost = particle(i).Cost;
            % mise a jour du gBest
            if particle(i).Best.Cost < gBest.Cost
                gBest = particle(i).Best;
            end
        end
    end %fin de la boucle du parcour des populations
    % sauvegarder la valeur du Best Cost pour chaque iteration 
    bestCosts(it) = gBest.Cost;
    % afficher les infos de chaque iteration
    %disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(bestCosts(it))]);
    %1-F.W.: poids fixe
    %w=w;
    %2-W.D.: réduction de poids
    w = w * wdamp;        % a chaque itération w va se diminuer! pour qu il peut y avoir une convergence progressive
    %3-R.I.W.: poids d'inertie aléatoire
    %w = 1 + rand()/2;     %[O.5..1] 
end %fin de la boucle d'iteration max pour l execution du programme
 
%% Resultats:
gBest
figure(666);
plot(bestCosts,'LineWidth',2);
title('Convergence du PSO');
xlabel('Iterations');
ylabel('Best Cost');
figure(777);%pour une meilleure visualisation!
semilogy(bestCosts, 'LineWidth', 2, 'Color', 'Red'); %ploter bestCosts avec taille de police =2, couoleur rouge
title('Convergence du PSO');
xlabel('Iterations');
ylabel('Best Cost');
grid on; %afficher la grille

