function [dist] = curvedist(lats1,lons1,lats2,lons2)
% calculate distance between curves
% longitude should be -180 to 180 

for i = 1:length(lats1)
    min = Inf;
    for j = 1:length(lats2)
        if lldistkm([lats1(i) lons1(i)], [lats2(j) lons2(j)]) < min;
            min = lldistkm([lats1(i) lons1(i)], [lats2(j) lons2(j)]);
        end
    end
    mins(i) = min;
end

dist = median(mins);
clear ans i j lats1 lats2 lons1 lons2 min
end

