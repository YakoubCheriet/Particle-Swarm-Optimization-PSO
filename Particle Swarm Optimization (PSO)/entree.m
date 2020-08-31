function [popSize,maxIter, nbrVar] = entree()
state=false;         %Not OK :(
popSize=0;
maxIter=0;
nbrVar=0;
%Lire les variables d''entrée:
while ~state
    if popSize==0
    popSize=input('Entrez la taille de la population (taille d''essaim):      ');
    end
    if maxIter==0
    maxIter=input('Entrez le nombre maximal d''itérations (exécution du prg): ');
    end
    if (nbrVar==0 || nbrVar>2)
    nbrVar=input('Entrez le nombre de variables (Dimensions), eg: 1 ou 2 : ');
    end
    if (popSize~=0 && maxIter~=0 && (nbrVar==1 || nbrVar==2))
        state=~state; %It's OK :)
        break;
    end
end
end

