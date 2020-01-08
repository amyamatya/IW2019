%% Combine Argo data (2000 - 2019)
%  Columns: Float ID, Date, Latitude, Longitude (-180 to 180), Longitude (0 to 360)

folderz = 2000:2019;
count = 1;

for i = 1:length(folderz)
    addpath(char("/Users/aamatya/Desktop/Argo/" + folderz(i)));
    list = dir(char("/Users/aamatya/Desktop/Argo/" + folderz(i)));
    
    for j = 3:length(list)
        id = ncread(list(j).name, 'PLATFORM_NUMBER');
        lat = ncread(list(j).name, 'LATITUDE');
        lon = ncread(list(j).name, 'LONGITUDE');
        qf = ncread(list(j).name, 'POSITION_QC');
        [rows, cols] = size(id);
        
        for k = 1:cols
            
            % check quality flag
            if str2num(qf(k)) > 2
                continue
                
            else
                argoData(count, 1) = str2double(id(:,k)); % occupy Float ID
                
                % handle str2double errors
                if isnan(str2double(id(:,k)))
                    digits = 1;
                    while ~isnan(str2double(id(digits, k)))
                        digits = digits + 1;
                    end
                    argoData(count, 1) = str2double(id(1 : digits(1) - 1, k));
                end
                
                argoData(count, 2) = str2num(erase(list(j).name,"_prof.nc")); % occupy Date
                argoData(count, 3) = lat(k); % occupy Latitude
                argoData(count, 4) = lon(k); % occupy Longitude (-180 to 180)
                count = count + 1;
            end
        end
    end
end

% occupy Longitude (0 to 360)
for a = 1:length(argoData)
    if argoData(a,4) < 0
        argoData(a,5) = argoData(a,4) + 360;
    else argoData(a,5) = argoData(a,4);
    end
end

argoData = sortrows(argoData, 1);
clear i j cols digits id rows lat lon count list m folderz qf a