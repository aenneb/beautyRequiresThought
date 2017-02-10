# beautyRequiresThought

This repository contains all data and analysis files related to the article "Beauty requires thought. Cognitive tasks reduce beauty" Brielmann & Pelli (2017).
-----
Overview of the data structure

all data is stored in allData_newSave.mat
- allAvgPleasureDuring: average pleasure per trial during the initial 30s of stimulus presentation
- allDecayDur: time in s until pleasure is < 3 per trial
- allFinalRatings: final beauty ratings (0-3) per trial
- allIsNbackTrial: index for presence or absence of task; 0 = without task; 1 = with task
- allMaxPleasureDuring: max. pleasure per trial during the initial 30s of stimulus presentation
- allObjectType: index for stimulus kind; 1 = self-selected beautiful; 2 = high-valence IAPS; 3 = mid-valence IAPS; 4 = Jolly Rancher candy; 5 = IKEA furniture; 6 = teddy bear
- all Ratings: pleasure ratings over time (1/s) per trial
- allTimes: exact time at which each pleasure rating was sampled
- beautyCat: indicates for each trial the beauty rating of the same participant for the same stimulus kind WITHOUT task
- expGroup: index for which experiment the data belongs to; 1 = Expt.1A,B; 2 = Expt.2
- experiment: index specifying the exact experiment; 1 = Expt.1A; 2 = Expt.1B; 3 = Expt.2
- rSteady: analytic solution for rSteady per trial
- rating_inter: interpolated time course of pleasure per trial
- subjectID: subject identifier

-----
Short descriptions of included .m files

- analyticSolution_rSteady: calculates the analytic solution for rSteady (Eqs. 4-6) for any given input; called by run_analyticSolution_rSteady
- fit_saturationFunction: fits all competing models for the relation between average pleasure with and without task
- fitAllAverages_byStimulusType: calculates average pleasure over time per condition and fits the model to this data; calls fitEmotionTrackerData.m
- fitEmotiontrackerData: sets up and runs fminsearch to find best model fit; called by fitAllAverages_byStimulusType; calls RModel_averages
- find_pleasureThresholdForBeauty: given the raw beauty and pleasure ratings, finds a threshold pleasure for reporting "perhaps yes" reg. felt beauty and plots it in boxplots and vertical histograms for pleasure without task
- RModel_averages: fits the model to averaged time course data of pleasure. All parameters are free parameters; calles by fitEmotiontrackerData 
- RModel_singleTrial: fits the model to data of single trials. Only free parameter is rSteady, all other parameters are fixed to values obtained with RModel_averages; called by plot_residuals_byExperiment_stimType
- run_analyticSolution_rSteady: calculates average pleasure over time per condition and analytic solution for rSteady; calls analyticSolution_rSteady
- plot_residuals_byExperiment_stimType: computes and plots average residuals per experiment and stimulus kind; calls RModel_singleTrial 
