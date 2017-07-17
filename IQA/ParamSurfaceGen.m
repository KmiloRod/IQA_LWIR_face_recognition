%PARAMSURFACEGEN This script allows to generate a surface plot of
%recogniton accuracy vs the parameters kappa and rho from the results of
%the ParamRank function, for analysis of dependency of the algorithm with
%the parameters values.

Kappa = 10:5:105;
rho = 5:24;
[X,Y] = meshgrid(Kappa,rho);
Rank1acc = sum(TotalRank==1,2)./size(TotalRank,2);
Rank1acc = permute(Rank1acc,[1 3 2]);
surface(X,Y,Rank1acc');
view(3)
xlabel('Kappa')
ylabel('Rho')
zlabel('Rank 1 accuracy')
title('UND Pristine')