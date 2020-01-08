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

clearvars -except argoData merData merCount distArray

%% Are the nearest Argos close enough?

% average distance between each Mermaid and nearest Argo for each search condition
[rows, cols] = size(distArray);
for i = 1:cols
    for j = 1:merCount(1,2)
        theDists(j,i) = lldistkm([argoData(distArray(j, 1),3) argoData(distArray(j, 1),4)],[merData(j, 3)...
            merData(j, 4)]);
        theDists(j,i) = lldistkm([argoData(distArray(j, 2),3) argoData(distArray(j, 2),4)],[merData(j, 3)...
            merData(j, 4)]);
    end
end

for i = 1:cols
    mean(i) = mean(theDists(:,i));
end


% example: plot first matchup for both conditions
filename = gunzip('gshhs_c.b.gz', tempdir);
shorelines = gshhs(filename{1});
delete(filename{1})
levels = [shorelines.Level];
land = (levels == 1);

% all years
argoIdx = distArray(1:merCount(1,2), 1);
merIdx = 1:merCount(1,2);
latMin = min(min(argoData(argoIdx,3)) , min(merData(merIdx, 3)));
latMax = max(max(argoData(argoIdx,3)) , max(merData(merIdx, 3)));
lonMin = min(min(argoData(argoIdx,5)) , min(merData(merIdx, 5)));
lonMax = max(max(argoData(argoIdx,5)) , max(merData(merIdx, 5)));
h = worldmap([latMin-1 latMax+1],[lonMin-1 lonMax+1]);
lg1 = scatterm(argoData(argoIdx,3), argoData(argoIdx,5), 12,'filled','ro');
lg2 = scatterm(merData(merIdx, 3), merData(merIdx, 5), 12,'filled','bo');
geoshow(shorelines(land),  'FaceColor', [0.9 0.9 0.9]);
p = findobj(h,'type','patch'); 
set(p,'FaceColor',[.6 .7 .95]);
legend([lg1 lg2],'Argo','Mermaid');
title("Nearest Argo points, avg distance = " + sprintf('%.03f',mean1) + ' km');

% all years, same month
argoIdx = distArray(1:merCount(1,2), 2);
merIdx = 1:merCount(1,2);
latMin = min(min(argoData(argoIdx,3)) , min(merData(merIdx, 3)));
latMax = max(max(argoData(argoIdx,3)) , max(merData(merIdx, 3)));
lonMin = min(min(argoData(argoIdx,5)) , min(merData(merIdx, 5)));
lonMax = max(max(argoData(argoIdx,5)) , max(merData(merIdx, 5)));
h = worldmap([latMin-.5 latMax+1],[lonMin-1 lonMax+1]);
lg1 = scatterm(argoData(argoIdx,3), argoData(argoIdx,5), 12,'filled','ro');
lg2 = scatterm(merData(merIdx, 3), merData(merIdx, 5), 12,'filled','bo');
geoshow(shorelines(land),  'FaceColor', [0.9 0.9 0.9]);
p = findobj(h,'type','patch'); 
set(p,'FaceColor',[.6 .7 .95]);
legend([lg1 lg2],'Argo','Mermaid');
title("Nearest Argo points within same month, avg distance = " + sprintf('%.03f',mean2) + ' km');

clearvars -except argoData merData merCount distArray








