% perform a bootstrap test on significant deviation of AUC of the ROC
% curves from 0.5

matFile=fullfile(fileparts(mfilename('fullpath')),'allData_newSave.mat');
load(matFile);
rSteady = rSteady(expGroup==1')';
allObjectType = allObjectType(expGroup==1);
allIsNbackTrial = allIsNbackTrial(expGroup==1);
allFinalRating = allFinalRating(expGroup==1);

for iType=1:6
    objectTypes=iType;
    
    classes = -1*allIsNbackTrial(allObjectType==iType)+1;
    pleasure_values = rSteady(allObjectType==iType);
    input = [classes; int8(pleasure_values)]';
    
    p_pleasure(iType) = auc_bootstrap(input);
    [AUC_pleasure(iType) AUC_CI_pleasure(iType,:)] = auc(input, 0.05, 'boot');
    
    
    beauty_values = allFinalRating(allObjectType==iType);
    input = [classes; int8(pleasure_values)]';
    
    p_beauty(iType) = auc_bootstrap(input);
    [AUC_beauty(iType) AUC_CI_beauty(iType,:)] = auc(input, 0.05, 'boot');
    
end