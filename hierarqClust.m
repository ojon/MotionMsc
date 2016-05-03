%Realiza agrupamento hierarquico e monta um dendrograma

selectM = double(distM);           % cast para double
D = squareform(selectM);           % mudan�a de formato para representa��o 1D
Z = linkage(D, 'average');         % realiza a clusteriza��o hierarquica
leafOrder = optimalleaforder(Z,D); % ordena as folhas de forma a maximizar a soma 
                                   % das similiaridades entre folhas adjacentes
%plot
figure();
H = dendrogram(Z,0, 'Reorder',leafOrder, 'Orientation','left','labels', labels);
