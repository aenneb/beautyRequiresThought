%--- access all participants' data
%--- get means per condition
%--- calculate analytic solution for rSteady per condition
%% clear
clear
close all

%% access all data
load allData_newSave

counter = 1;

for nBack = 0:1
   for category = 1:6 %CAUTION when fitting data of less stimulus categories!!! Reduce counter then
      
       meanRatings(counter,:) = nanmean(allRatings(allIsNbackTrial==nBack &...
           allObjectType==category, 1:89));
       sdRatings(counter,:) = nanstd(allRatings(allIsNbackTrial==nBack &...
           allObjectType==category, 1:89));
       seRatings(counter,:) = sdRatings(counter,:) / sqrt(sum(allIsNbackTrial==nBack &...
           allObjectType==category)-1);
       
       conditions.nBack(counter) = nBack;
       conditions.category(counter) = category;
       
       counter = counter+1;
       
   end
end

data = meanRatings;
tOn = zeros(size(meanRatings,1),1);
tOff = ones(size(meanRatings,1),1)*30;
% for candy trials, set tOff to a bit more than 30 s, as rinsing takes some
% time
tOff(conditions.category==4) = 38;

t = 1:89;

%% get the solution for rSteady from Denis' equation

rSteady = analyticSolution_rSteady(data, tOn, tOff, t);
