%este script realiza a validacao cruzada de k folds para o KNN

%necessita das variáveis carregadas:
%distM: matriz de distancias de todo conjunto de dados
%enumClasses: vetor com inteiros correspondentes 
%             as classes de cada coluna 


k = 10;                                     %k folds
kNeighbors = 3;                             %kNeighbors vizinhos

indices = crossvalind('Kfold',labels,k);    %particionamento para k-folds
misses = 0;
hits = 0;

classHitsMisses = zeros(2,max(enumClasses));
stest = 0

for i = 1:k
    test = (indices == i); 
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
    
    %para cada elemento do conjunto de testes
    for testIndex=1:size(nearestIndexes,1)
        %olho para os rotulos dos exemplos mais proximos
        nearestClasses = labelsTrain(nearestIndexes(testIndex,:),:);
        %o mais comum é o rotulo inferido
        if size(nearestClasses,1) > 1
            predictedLabel = mode(nearestClasses);                
        else
            predictedLabel = nearestClasses;
        end
        %comparo com o rotulo do elemento de teste
        if predictedLabel == labelsTest(testIndex)
            hits =  hits + 1;
            classHitsMisses(1,labelsTest(testIndex)) = classHitsMisses(1,predictedLabel) + 1;
        else
            misses = misses + 1;
            classHitsMisses(2,labelsTest(testIndex)) = classHitsMisses(2,labelsTest(testIndex)) + 1;
        end
    end    
end
classHitsMisses
accuracy = hits/(hits + misses)