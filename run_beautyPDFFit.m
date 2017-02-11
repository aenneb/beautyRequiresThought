% reverse the quantization of beauty, i.e., derive B* from B

%% clear
clear
close all

%% set working directory and access all data
cd('/Users/aennebrielmann/Google Drive/PhD/studies/N-back study/data_analyses/')

load allData_newSave

%% for single stimulus fitting:
% selectedStim = 6;
%
% categories = allObjectType(expGroup==1 & allObjectType==selectedStim);
% taskIndices = allIsNbackTrial(expGroup==1 & allObjectType==selectedStim);
%
% measuredBeauty = allFinalRating(expGroup==1 & allObjectType==selectedStim)';

%% else
categories = allObjectType(expGroup==1);
taskIndices = allIsNbackTrial(expGroup==1);

measuredBeauty = allFinalRating(expGroup==1)';
measuredPleasure = rSteady(expGroup==1)';

%% get empirical PDF
condCount=1;

for withTask = 0:1
    
    condCount=1;
    
    for condition = 1:6
        
        for beauty = 0:3
            
            probBeauty(withTask+1, condCount, beauty+1) = ...
                sum(measuredBeauty(categories==condition & taskIndices==withTask)<(beauty+1) &...
                measuredBeauty(categories==condition & taskIndices==withTask)>=beauty)/...
                sum(~isnan(measuredBeauty(categories==condition & taskIndices==withTask)));
            
        end
        
        meanBeauty(condCount, withTask+1) = nanmean(measuredBeauty(categories==condition & taskIndices==withTask));
        meanPleasure(condCount, withTask+1) = nanmean(rSteady(categories==condition & taskIndices==withTask));
        condCount = condCount+1;
        
    end
end
meanBeauty = meanBeauty(:);
meanPleasure = meanPleasure(:);
%% fit
[parameters, cost] = fit_beautyQuantization(probBeauty, categories);
modelPredictions = model_beautyQuantization(parameters, categories);

%% plot
counter = 1;
obsBeauty = probBeauty(:);
predictedBeauty = modelPredictions(:);

figure(1);clf;
for ii = 1:12
    
    subplot(2,6,ii)
    hold on
    box off
    plot(obsBeauty(counter:counter+3), 'o')
    plot(predictedBeauty(counter:counter+3),'+')
    counter = counter+3;
end

%% plot B* against B
figure(2)
hold on
box off
axis square
plot(parameters(1:12), meanBeauty, 'o')
axis([0 4 0 4])
plot([0 4], [0 4], '--k')

%% plot B* against P
figure(3);clf;
hold on
box off
axis square
plot(meanPleasure(6), parameters(6), 'o')
plot(meanPleasure(12), parameters(12), 'or')
axis([-.5 10 0 4])
% % proportionality
% slope = (parameters(1:12))\(meanPleasure-1);
% plot([0 4], [1 slope*4], 'k')
% RMSE = sqrt(nanmean(((meanPleasure-1) - (slope.*parameters(1:12))).^2))
% need new regression to plot slope
reg = polyfit(meanPleasure, parameters(1:12),1);
plot([-.5 10], [reg(2)+reg(1)*-.5 reg(2)+reg(1)*10], '--k')
RMSE = sqrt(nanmean((parameters(1:12) - (reg(2)+reg(1).*meanPleasure)).^2))
rho = corr(parameters(1:12), meanPleasure)



