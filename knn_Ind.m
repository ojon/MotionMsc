%semelhante ao kNNxValid porem realiza a validicao LOSOCV

actors = fileLabels(:,6:7);

enumActors = [];

for i=1:size(actors,1)
   if  sum(actors(i,:) == 'bd') == 2
       enumActors = [enumActors 1];
   elseif  sum(actors(i,:) == 'bk') == 2
       enumActors = [enumActors 2];
   elseif  sum(actors(i,:) == 'dg') == 2
       enumActors = [enumActors 3];
   elseif  sum(actors(i,:) == 'mm') == 2
       enumActors = [enumActors 4];
   elseif  sum(actors(i,:) == 'tr') == 2
       enumActors = [enumActors 5];
   end

end

accuracies = [];
total_hits = 0;
total_misses = 0;

for i = 1:5
    % o conjunto de teste neste caso corresponde as amostras de um
    % indivíduo
    test = (enumActors == i); 
    train = ~test;
    labelsTrain = enumClasses(train,:);
    labelsTest = enumClasses(test,:);   
    distM4min = distM + int64(eye(size(distM)))*(max(max(distM))+1);
    
    %selM é a matrix das distancias entre o dados 
    %de teste (linhas) e os de treinamento (colunas)   
    selM = distM4min(test,train);
        
    [m mi] = sort(selM,2);    
    %indices dos k elesment mais proximos dos dados de teste    
    nearestIndexes = mi(:,1:kNeighbors);
    
    hits = 0;
    misses = 0;
    
    %para cada elemento do conjunto de testes
    for testIndex=1:size(nearestIndexes,1)
        %olho para os rotulos dos exemplos mais proximos
        nearestClasses = labelsTrain(nearestIndexes(testIndex,:),:);
        %o mais comum é o rotulo inferido
        predictedLabel = mode(nearestClasses);                
        %comparo com o rotulo do elemento de teste
        if predictedLabel == labelsTest(testIndex)
            total_hits =  total_hits + 1;
            hits =  hits + 1;
        else
            total_misses = total_misses + 1;
            misses = misses + 1;
        end
        
    end
    
    accuracies = [accuracies hits/(hits + misses)];
    
end
accuracies;
accuracy = total_hits/(total_hits + total_misses)