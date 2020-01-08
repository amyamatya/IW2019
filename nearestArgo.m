%% [distArray] = for each Mermaid point, find nearest Argo

addpath('/Users/aamatya/Desktop/SOCCOM/Open Source Functions');

% 1 - find nearest across all time
for i = 1:length(merData)
    minDist = Inf;
    for j = 1:length(argoData)
        if lldistkm([merData(i, 3) merData(i, 4)], [argoData(j, 3) argoData(j, 4)]) < minDist
            minDist = lldistkm([merData(i, 3) merData(i, 4)], [argoData(j, 3) argoData(j, 4)]);
            distArray(i,1) = j; % index of nearest Argo
        else, continue
        end
    end
end

% 2 - find nearest in same month but any year
argoMonth = month(num2str(argoData(:,2)), 'yyyymmdd');
merMonth = month(num2str(merData(:,2)),'yyyymmdd');

for i = 101:length(merData)
    minDist = Inf;
    for j = 1:length(argoData)
        if argoMonth(j) ~= merMonth(i)
            continue
        else
            if lldistkm([merData(i, 3) merData(i, 4)], [argoData(j, 3) argoData(j, 4)]) < minDist
                minDist = lldistkm([merData(i, 3) merData(i, 4)], [argoData(j, 3) argoData(j, 4)]);
                distArray(i,2) = j;
            end
        end
    end
end

% 3 - find nearest in same month, each year
argoYear = year(num2str(argoData(:,2)), 'yyyymmdd');
merYear = year(num2str(merData(:,2)),'yyyymmdd');

for i = 2000:2019
    for j = 101:length(merData)
        minDist = Inf;
        for k = 1:length(argoData)
            if ((argoMonth(k) ~= merMonth(j)) & (argoYear ~= i))
                continue
            else
                if lldistkm([merData(j, 3) merData(j, 4)], [argoData(k, 3) argoData(k, 4)]) < minDist
                    minDist = lldistkm([merData(j, 3) merData(j, 4)], [argoData(k, 3) argoData(k, 4)]);
                    distArray(j,2) = k;
                end
            end
        end
    end
end

clear argoMonth merMonth argoYear merYear i j k


