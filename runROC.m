% runs an ROC analysis on pleasure per stimulus kind
% can we distinguish trials with and without task based on pleasure?

matFile=fullfile(fileparts(mfilename('fullpath')),'allData_newSave.mat');
load(matFile);
rSteady = rSteady(expGroup==1');
allObjectType = allObjectType(expGroup==1);
allIsNbackTrial = allIsNbackTrial(expGroup==1);
allFinalRating = allFinalRating(expGroup==1);

for iType=1:6
   objectTypes=iType;
   roc=ROC(rSteady,allIsNbackTrial,allObjectType,objectTypes); %used to run with allMaxPleasureDuring
   
   figure(iType);
   clf;
   xlabel('P(false alarm)');
   ylabel('P(hit)');
   title('Probabability of detecting the secondary task');
   axis square
   
   plot(roc.pFalseAlarm,roc.pHit,'-b');
   text(.4,0.12,sprintf('Pleasure, P = %.2f',roc.area),'FontSize',24,'Color','b');
   for lambda=1:8
      for i=1:length(roc.lambda)
         if lambda>=roc.lambda(i) && lambda<roc.lambda(i+1)
            text(roc.pFalseAlarm(i),roc.pHit(i),sprintf('%.0f',lambda),'FontSize',24,'Color','b');
         end
      end
   end
   text(1,1,sprintf('%.0f',9),'FontSize',24,'Color','b');
   
   
   roc=ROC(allFinalRating,allIsNbackTrial,allObjectType,objectTypes);
   hold on
   plot(roc.pFalseAlarm,roc.pHit,'- r');
   text(.4,0.05,sprintf('Beauty, P = %.2f',roc.area),'FontSize',24,'Color','r');
   for i=1:length(roc.lambda)
      lambda=roc.lambda(i);
      if isfinite(lambda)
         text(roc.pFalseAlarm(i)-0.03,roc.pHit(i),sprintf('%.0f',lambda),'FontSize',24,'Color','r');
      end
   end
   text(1-0.03,1,sprintf('%.0f',3),'FontSize',24,'Color','r');
   axis square
   
   text(0.4,0.19,['Stimuli: ' sprintf('%.0f ',objectTypes)],'FontSize',24,'Color','k');
end