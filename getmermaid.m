%% [merData] = Combine Mermaid data
%  Columns: Float ID, Date, Latitude, Longitude (-180 to 180), Longitude (0 to 360)

cd('/Users/aamatya/Desktop/Junior IW');
addpath('/Users/aamatya/Desktop/SOCCOM/Open Source Functions');
theFilenames = [1 2 4:6 8:13 16:25 27:29 31:50 52:53];

count = 1;
for i = 1:length(theFilenames)
    if i < 8
        data = urlread(char("http://geoweb.princeton.edu/people/simons/SOM/P00" + theFilenames(i) + "_all.txt"));
    else
        data = urlread(char("http://geoweb.princeton.edu/people/simons/SOM/P0" + theFilenames(i) + "_all.txt"));
    end
    
    data = strsplit(data);
    data(length(data)) = [];
    latId = 4; % index of first latitude
    lonId = 5; % index of first longitude
    dateId = 2; % index of first date
    
    % resize, remove unwanted columns
    while dateId < length(data)
        merData(count, 1) = theFilenames(i); % occupy Float ID
        merData(count, 2) = yyyymmdd(datetime(data(dateId),'ConvertFrom','dd-MMM-yyy')); % occupy Date
        merData(count, 3) = str2double(cell2mat(data(latId))); % occupy Latitude
        merData(count, 4) = str2double(cell2mat(data(lonId))); % occupy Longitude (-180 to 180)
        
        % occupy Longitude (0 to 360)
        if merData(count, 4) < 0
            merData(count, 5) = merData(count, 4) + 360;
        else
            merData(count, 5) = merData(count, 4);
        end
        
        % increment
        latId = latId + 15;
        lonId = lonId + 15;
        dateId = dateId + 15;
        count = count + 1;
        
    end
end

% remove NaNs
nanIds = find(isnan(merData(:,3)));
merData(nanIds, :) = [];

% remove same-day/next-day measurements
dayCount = 0;
for i = 1:length(merData)
    if merData(i, 2) == dayCount
                merData(i,1) = 0;
    else
        if abs(merData(i,2) - dayCount) <= 1
                        merData(i,1) = 0;
        else
            dayCount = merData(i,2);
            continue;
        end
    end
end
merData(find(merData(:,1) == 0),:) = [];

clear count data dateId dayCount i latId lonId nanIds theFilenames
%% [merCount] = Find length and starting index for each float 
currentFloat = 0;
currentIdx = 0;

% Float frequency
for i = 1:length(merData)
    if merData(i, 1) ~= currentFloat
        currentFloat = merData(i, 1);
        currentIdx = currentIdx + 1;
        merCount(currentIdx, 1) = currentFloat;
        merCount(currentIdx, 2) = 1;
    else
        merCount(currentIdx, 2) = merCount(currentIdx, 2) + 1;
    end
end

% Starting indices
merCount(1,3) = 1; 
for i = 1:length(merCount)-1
    merCount(i+1,3) = merCount(i,2) + merCount(i,3);
end

clear i j size ans count nanIds theFilenames dateId latId lonId data currentIdx currentFloat
%% How frequently do Mermaids surface?

for i = 1:length(merCount)
    merCount(i,4) = 0;
    for  j = 1:merCount(i,2) - 1
        in1 = datenum(num2str(merData(merCount(i,3)+j-1, 2)),'yyyymmdd');
        in2 = datenum(num2str(merData(merCount(i,3)+j, 2)),'yyyymmdd');
        time = daysact(in1, in2);
        merCount(i,4) = merCount(i,4) + time;
    end
    merCount(i,4) = merCount(i,4) / (merCount(i,2) - 1);
end

average = mean(merCount(:,4));
merCount(:,4) = [];

clear i in1 in2 j time

%% Remove float launch errors

for i = 1:length(merCount) - 1
    outliers = find(isoutlier(merData(merCount(i,3):(merCount(i+1,3) - 1), 3)));
    merData(outliers + merCount(i,3) - 1,1) = 0;
end

merData(find(merData(:,1) == 0),:) = [];
clear i outliers

% remember to update merCount




