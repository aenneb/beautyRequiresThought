%--- access all participants' data
%--- get means per condition, as the single-trial data is way too noisy to
%be fit and fit the model to these averages with all parameters set to be
%free
%% clear
clear
close all

%% access all data and compute averages per condition
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
dataSetName = 'stimulusCategory';

%% get fits

tOn = zeros(size(meanRatings,1),1);
tOff = ones(size(meanRatings,1),1)*30;
% for candy trials, set tOff to a bit more than 30 s, as rinsing takes some
% time
tOff(conditions.category==4) = 38;

fitEmotionTrackerData(data, dataSetName, tOn, tOff);

%% add variable encoding the conditions to the data set as well as the mean
% Ratings per condition (and SEM!) to facilitate later plotting of data vs. fit
save([dataSetName, '_modelFit'], 'conditions', 'meanRatings', 'sdRatings', 'seRatings',...
    '-append');