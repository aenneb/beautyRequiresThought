% fit all suggested models to the relation between mean pleasure per stimulus 
% kind with and without task
%% clear
clear
close all
%% access all data, calculate means per condition
load allData_newSave

for object = 1:6
    pleasure_without(object) = nanmean(rSteady(expGroup==1 & allObjectType==object&allIsNbackTrial==0));
    pleasure_with(object) = nanmean(rSteady(expGroup==1 & allObjectType==object&allIsNbackTrial==1));
    
    beauty_without(object) = nanmean(allFinalRating(expGroup==1 & allObjectType==object&allIsNbackTrial==0));
    beauty_with(object) = nanmean(allFinalRating(expGroup==1 & allObjectType==object&allIsNbackTrial==1));
end

%% fit saturation model on pleasure
sqErr_step = @(parameters) sqrt(sum([(pleasure_with(pleasure_without<parameters(1))-pleasure_without(pleasure_without<parameters(1))).^2 ... 
    (pleasure_with(pleasure_without>=parameters(1))-...
    (pleasure_without(pleasure_without>=parameters(1))-parameters(2).*(pleasure_without(pleasure_without>=parameters(1))-parameters(1)))).^2])/6)

pleasureStart = [1 .5];
 
[pEst, sqErr] = fminunc(sqErr_step, pleasureStart);
predPleasure = [pleasure_without(pleasure_without<pEst(1))...
    pleasure_without(pleasure_without>=pEst(1))-pEst(2).*(pleasure_without(pleasure_without>=pEst(1))-pEst(1))];
measuredPleasure = [pleasure_with(pleasure_without<pEst(1)) pleasure_with(pleasure_without>=pEst(1))];

RMSE = sqrt(nanmean((measuredPleasure-predPleasure).^2))
r = corr(measuredPleasure(:), predPleasure(:))

%% alternative model: simple proportionality
reg = pleasure_without'\pleasure_with'
RMSE_lin = sqrt(mean((pleasure_without.*reg - pleasure_with).^2))

%% alternative model: compulsory averaging
sqErr_avg = @(gain) sqrt(nanmean((gain.*pleasure_without + (1-gain)*2.57 - pleasure_with).^2));

pleasureStart = [.5];
 
[pEst, sqErr] = fminunc(sqErr_avg, pleasureStart);

RMSE = sqrt(nanmean((pEst.*pleasure_without + (1-pEst)*2.57 - pleasure_with).^2))
