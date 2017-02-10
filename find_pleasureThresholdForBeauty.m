% find the threshold pleasure for beauty being reported as experienced
% based on the beauty ratings and plot it

%% clear
clear
close all

%% access all data, specify the experiments to work with
load allData_newSave
stimuli = allObjectType(expGroup==1 & allIsNbackTrial==0);
conditionIndices = allIsNbackTrial(expGroup==1 & allIsNbackTrial==0);
measuredBeauty = allFinalRating(expGroup==1 & allIsNbackTrial==0);
measuredPleasure = rSteady(expGroup==1 & allIsNbackTrial==0)';

%% get empirical means
condCount = 1;

for cond = unique(conditionIndices)
    
    stimCount=1;
    
    for stim = unique(stimuli)
        
        meanBeauty(condCount, stimCount) = nanmean(measuredBeauty((stimuli==stim & conditionIndices==cond)));
        sdBeauty(condCount, stimCount) = nanstd(measuredBeauty((stimuli==stim & conditionIndices==cond)));
        
        meanPleasure(condCount, stimCount) = nanmean(measuredPleasure(stimuli==stim & conditionIndices==cond));
        sdPleasure(condCount, stimCount) = nanstd(measuredPleasure(stimuli==stim & conditionIndices==cond));
        
        stimCount = stimCount+1;
    end
    
    condCount = condCount+1;
end

stimCount=1;
for stim = unique(stimuli)
    
    for beautCount = 0:3
        
        thisPleasure = measuredPleasure(measuredBeauty==beautCount);
        thisStims = stimuli(measuredBeauty==beautCount);
        meanPealsure_perBeaut(beautCount+1, stimCount) = nanmean(thisPleasure(thisStims==stim));
        sdPealsure_perBeaut(beautCount+1, stimCount) = nanstd((thisPleasure(thisStims==stim)));
        
        nTrials_perBeaut(beautCount+1, stimCount) = sum(thisStims==stim);
    end
    
    thisPleasure = measuredPleasure(stimuli==stim);
    beautyThreshold_tmp(stim) = median(thisPleasure(measuredBeauty(stimuli==stim)==2));
    stimCount = stimCount+1;
end


beautyThreshold = median(beautyThreshold_tmp)

%% get empirical PDF
for stim = 1:6
    for pleasure = 0:floor(max(measuredPleasure))
        
        probPleasure(stim, pleasure+1) = ...
            sum(measuredPleasure(stimuli==stim)<(pleasure+1) &...
            measuredPleasure(stimuli==stim)>=pleasure)/...
            sum(~isnan(measuredPleasure(stimuli==stim)));
        
    end
end
%% plot boxplots
figure(1)
hold on
box off
boxplot(measuredPleasure, stimuli)
plot([1 size(meanPleasure, 2)], [beautyThreshold beautyThreshold], '--k')

%% alternative plot of histograms
figure(2); clf;
for ii = 1:6
    subplot(1,6,ii)
    hold on
    box off
    barh(1:13, probPleasure(ii,:),1)
    plot([0 0.4], [beautyThreshold beautyThreshold], '--k')
end






