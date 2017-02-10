%--- access data and model predictions
%--- plot the residuals per experiment and stimulus type
%% clear
clear 
close all

%% set working directory and access model fits, including mean ratings
cd(fileparts(mfilename('fullpath')))

load allData_newSave
%% define times
time = 1:90;
nFiles = size(allRatings,1);
tOn = zeros(nFiles,1);
tOff = ones(nFiles,1)*30;
tOff(allObjectType==4)=38; % offset is later for candy because its taste lingers

%% first get the model Predictions for each trial, then calculate residuals, get RMSE at the same time
for trial = 1:nFiles
    
    modelPrediction(trial,:) = RModel_singleTrial(rSteady(trial), tOn(trial), tOff(trial), time);
    residuals(trial,:) = modelPrediction(trial,:)-allRatings(trial,:);
    RMSE(trial) = sqrt(nanmean((modelPrediction(trial,:)-allRatings(trial,:)).^2));
end

%% average residuals per experiment and stimulus type
counter = 1;

for nBack = 0:1
    for stimulus = 1:5
        residuals_exp1(counter,:) = nanmean(residuals(allIsNbackTrial==nBack &...
            experiment==1 & allObjectType==stimulus,:));
        residuals_exp3(counter,:) = nanmean(residuals(allIsNbackTrial==nBack &...
            experiment==3 & allObjectType==stimulus,:));
        
        RMSE_exp1(counter) = nanmean(RMSE(allIsNbackTrial==nBack &...
            experiment==1 & allObjectType==stimulus));
        RMSE_exp3(counter) = nanmean(RMSE(allIsNbackTrial==nBack &...
            experiment==3 & allObjectType==stimulus));
        counter = counter+1;
    end
end

counter = 1;
for nBack = 0:1
    for stimulus = 1:6
        residuals_exp2(counter,:) = nanmean(residuals(allIsNbackTrial==nBack &...
            experiment==2 & allObjectType==stimulus,:));
        RMSE_exp2(counter) = nanmean(RMSE(allIsNbackTrial==nBack &...
            experiment==2 & allObjectType==stimulus));
        counter = counter+1;
    end
end

%% then plot
clf
figure(1)

% exp 1
for ii = 1:5
    subplot(3,6, ii)
    plot(time, residuals_exp1(ii,:), '-b');
    hold on
    plot(time, residuals_exp1(ii+5,:), '-r');
    text(10, 9, ['RMSE without = ' num2str(round(RMSE_exp1(ii),1))]);
    text(10, 7, ['        with = ' num2str(round(RMSE_exp1(ii+5),1))]);
    
    axis([min(time) max(time) -10 10])
    set(gca, 'XTick', 0:10:90)
    set(gca, 'XTickLabel', -30:10:60, 'fontsize', 10)
    xlabel('Time after stimulus offset (s)', 'fontsize', 12)
    ylabel('Residuals', 'fontsize', 12)
    box off
end

% exp 2
for ii = 1:6
    subplot(3,6, ii+6)
    plot(time, residuals_exp2(ii,:), '-b');
    hold on
    plot(time, residuals_exp2(ii+6,:), '-r');
    text(10, 9, ['RMSE without = ' num2str(round(RMSE_exp2(ii),1))]);
    text(10, 7, ['        with = ' num2str(round(RMSE_exp2(ii+6),1))]);
    
    axis([min(time) max(time) -10 10])
    set(gca, 'XTick', 0:10:90)
    set(gca, 'XTickLabel', -30:10:60, 'fontsize', 10)
    xlabel('Time after stimulus offset (s)', 'fontsize', 12)
    ylabel('Reesiduals', 'fontsize', 12)
    box off
end

% exp 3
for ii = 1:5
    subplot(3,6, ii+12)
    plot(time, residuals_exp3(ii,:), '-b');
    hold on
    plot(time, residuals_exp3(ii+5,:), '-r');
    text(10, 9, ['RMSE without = ' num2str(round(RMSE_exp3(ii),1))]);
    text(10, 7, ['        with = ' num2str(round(RMSE_exp3(ii+5),1))]);
    
    axis([min(time) max(time) -10 10])
    set(gca, 'XTick', 0:10:90)
    set(gca, 'XTickLabel', -30:10:60, 'fontsize', 10)
    xlabel('Time after stimulus offset (s)', 'fontsize', 12)
    ylabel('Residuals', 'fontsize', 12)
    box off
end

