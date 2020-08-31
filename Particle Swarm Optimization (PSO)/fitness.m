function fit=fitness(x)
 dim = length(x);     %taille du vecteur, plutôt dimension!
 switch dim
    case 1
         %(1) une dimension:
         fit=(x).^2 + (sin(x).^2);
    case 2
         %(2) plusieurs dimensions:
         %fit = sum((x).^2 + (sin(x).^2));
         X=x(1);
         Y=x(2);
         fit=(X^2 + Y^2);
    otherwise
      disp('Erreur !');%Never been reached due 2 entree funk :D
      exit; %Close app
 end
end
