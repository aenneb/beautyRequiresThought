# beautyRequiresThought

This repository contains all data and analysis files related to the article "Beauty requires thought. Cognitive tasks reduce beauty" Brielmann & Pelli (2017).

-----
Short descriptions of included .m files

- analyticSolution_rSteady: calculates the analytic solution for rSteady (Eqs. 4-6) for any given input; called by run_analyticSolution_rSteady
- fitAllAverages_byStimulusType: calculates average pleasure over time per condition and fits the model to this data; calls fitEmotionTrackerData.m
- fitEmotiontrackerData: sets up and runs fminsearch to find best model fit; called by fitAllAverages_byStimulusType; calls RModel_averages
- RModel_averages: fits the model to averaged time course data of pleasure. All parameters are free parameters; calles by fitEmotiontrackerData 
- RModel_singleTrial: fits the model to data of single trials. Only free parameter is rSteady, all other parameters are fixed to values obtained with RModel_averages; called by plot_residuals_byExperiment_stimType
- run_analyticSolution_rSteady: calculates average pleasure over time per condition and analytic solution for rSteady; calls analyticSolution_rSteady
- plot_residuals_byExperiment_stimType: computes and plots average residuals per experiment and stimulus kind; calls RModel_singleTrial 
