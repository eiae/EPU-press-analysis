%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               BVAR model                     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% HOUSEKEEPING
clear;
close all;
warning off;
clc;


%% PREAMBLE
% =========================================================================
% Settings 
% -------------------------------------------------------------------------
wdp = '\\gimecb01\data\ECB business areas\DGI\Databases and Programme files\EXT\ST_LATAM\models';

% change specs depending on country
cc = 'BR';
ar = 0.5;
lambda1 = 0.1;
lambda2 = 1;
lambda3 = 1;

% set input and ouput paths
excelPath = strcat(wdp,'\bvar_', cc,'\toolbox_4.2','\data.xlsx');
resultPath = strcat(wdp,'\bvar','\results');
mod_set = BEARsettings('BVAR', 'ExcelFile', excelPath); 

% read EPU combinations
EPU = readmatrix(fullfile(wdp, 'bvar', strcat(cc, '_EPU.csv')));
EPU = EPU(:,2:end);  % get rid of dates (already preprocessed in python)


%% SET MODEL
% =========================================================================

% Specification
% -------------------------------------------------------------------------
mod_set.frequency = 2;
% data frequency (1=yearly, 2= quarterly, 3=monthly, 4=weekly, 5=daily, 6=undated)

mod_set.startdate = '2003q1'; 
mod_set.enddate = '2019q4';

mod_set.varendo = ['01vix_lvl' ' ' '02epu_lvl' ' ' '03pcf_overgdp' ' ' '04gdp_qoq' ' ' '05cpi_qoq'];
mod_set.varexo='';

mod_set.lags = 4;
mod_set.const = 1;

% save paths
mod_set.results_path = fullfile(resultPath);

% save results
mod_set.results=1;
mod_set.plot=0;
mod_set.workspace=0;

% Estimation
% -------------------------------------------------------------------------
mod_set.prior=13;
% 11=Minnesota (univariate AR), 12=Minnesota (diagonal VAR estimates), 13=Minnesota (full VAR estimates)
% 21=Normal-Wishart(S0 as univariate AR), 22=Normal-Wishart(S0 as identity)
% 31=Independent Normal-Wishart(S0 as univariate AR), 32=Independent Normal-Wishart(S0 as identity)
% 41=Normal-diffuse
% 51=Dummy observations

mod_set.ar=ar;
mod_set.PriorExcel=0; % set to 1 if you want individual priors, 0 for default
mod_set.priorsexogenous=0; % set to 1 if you want individual priors, 0 for default

mod_set.lambda1=lambda1;
mod_set.lambda2=lambda2;
mod_set.lambda3=lambda3;
mod_set.lambda4=100;
mod_set.lambda5=0.001;
mod_set.lambda6=1;
mod_set.lambda7=0.1;
mod_set.lambda8=1;

mod_set.It=5000;  %5000
mod_set.Bu=2000;  %2000 
mod_set.hogs=0;  %1
mod_set.bex=1;

mod_set.scoeff=0; % sum-of-coefficients application (1=yes, 0=no)
mod_set.iobs=0; % dummy initial observation application (1=yes, 0=no)
mod_set.lrp=0; % Long run prior option

% Identification
% -------------------------------------------------------------------------
mod_set.IRFt=2;
% structural identification (1=none, 2=Cholesky, 3=triangular factorisation, 4=sign, zero, magnitude, relative magnitude, FEVD, correlation restrictions,
% 5=IV identification, 6=IV identification & sign, zero, magnitude, relative magnitude, FEVD, correlation restrictions)

% Applications
% -------------------------------------------------------------------------
mod_set.IRF=1;          
mod_set.IRFperiods=40;  
mod_set.F=1;            
mod_set.FEVD=0;         
mod_set.HD=0;           
mod_set.HDall=0; % if we want to plot the entire decomposition, all contributions (includes deterministic part)HDall
mod_set.CF=0;           
mod_set.CFt=1; % 1=standard (all shocks), 2=standard (shock-specific), 3=tilting (median), 4=tilting (interval)

mod_set.Fstartdate='2020q1'; % start date for forecasts (has to be an in-sample date; otherwise, ignore and set Fendsmpl=1)
mod_set.Fenddate='2024q4';   % end date for forecasts
mod_set.Fendsmpl=1;          % start forecasts immediately after the final sample period (1=yes, 0=no) has to be set to 1 if start date for forecasts is not in-sample
mod_set.Feval=0;             % activate forecast evaluation (1=yes, 0=no)
mod_set.hstep=1;             % step ahead evaluation
mod_set.window_size=0;       % window_size for iterative forecasting 0 if no iterative forecasting
mod_set.evaluation_size=0.5; % evaluation_size as percent of window_size                                      <                                                                                    -

mod_set.cband=0.84;    % confidence/credibility level for VAR coefficients
mod_set.IRFband=0.84;  % confidence/credibility level for impusle response functions
mod_set.Fband=0.84;    % confidence/credibility level for forecasts
mod_set.FEVDband=0.84; % confidence/credibility level for forecast error variance decomposition
mod_set.HDband=0.84;   % confidence/credibility level for historical decomposition


%% RUN MODEL
% =========================================================================

% save in different files and run BEAR for each combi
for comb = 1:size(EPU,2)
    
    mod_set.results_sub=strcat('results_BVAR_' , cc, '_EPUcomb_', int2str(comb));
    BEARmain(mod_set, EPU, comb);  
    
end






