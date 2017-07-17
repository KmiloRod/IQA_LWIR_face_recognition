function TSResults = ResultsIdAndVerifTS_Class138_All(Distortion,Database,Thresholds)
%RESULTSIDANDVERIFTS_ALL Tests the TST LWIR face recognition algorithm
% with NSS features added, on several threshold values.
% [TSResults] = RESULTSIDANDVERIFTS_ALL(Distortion, Database, Thresholds)
% receives as inputs a Distortion type, a Database to be used, and a vector
% of threshold values (Thresholds). The function performs the tests on
% the Probe and ProbeN or Test and TestN image subsets of the specified
% distortion.
%
% The function returns as output a TSResults matrix containing the
% Recognition and False Alarm rates for identification and verification
% performance evaluation, and plots the corresponding ROC and CMC.
% The last three rows of TSResults corresponds to the threshold values,
% Genuine Acceptance Rates and False Acceptance Rates respectively. The
% first row also includes the threshold values, the second row the False
% Alarm Rates and the remaining rows the Recognition Rate for each rank,
% which depends on the number of subjects in the database gallery.
%
% Database = String belonging to {UND, PUJ, FONE}
% Distortion = String belonging to {[], Pristine, AWN, BLUR, NU, JPG}
%
% (c) 2016 - 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%========================================================================

tic
close all

if isempty(Distortion)
    TestFolder = 'Test';
    TestNFolder = 'TestN';
else
    if exist(strcat('Probe', Distortion))
        TestFolder = strcat('Probe', Distortion);
        TestNFolder = strcat('ProbeN', Distortion);
    else
        TestFolder = strcat('Test_', Distortion);
        TestNFolder = strcat('TestN_', Distortion);
    end
end

disp('Calculating genuine scores...')
[idTPRates, ~, verifRates, ~] = idAndVerifResultsClass138(TestFolder,Database,Thresholds);
disp('Calculating impostor scores...')
[~, idFalseAlarmRates, ~, veFalseAlarmRates] = idAndVerifResultsClass138(TestNFolder,Database,Thresholds);

TSResults = [Thresholds; idFalseAlarmRates; idTPRates; nan(1,length(Thresholds)); Thresholds; verifRates; veFalseAlarmRates];
csvwrite('TSResults.csv',TSResults);

figure;
plot(veFalseAlarmRates,verifRates,'-b','LineWidth',2);
%title('ROC Curve');
xlabel('False Accept Rate');
ylabel('Genuine Accept Rate');
xlim([0, 1]);
ylim([0, 1]);
ax = gca; ax.FontSize = 14;

figure;
plot(1:size(idTPRates,1),idTPRates(:,1),'-r','LineWidth',2);
%title('CMC Curve');
xlabel('Rank');
ylabel('Recognition Rate');
xlim([1, size(idTPRates,1)])
ylim([0, 1]);
ax = gca; ax.FontSize = 14;

toc

load gong.mat
sound (y, Fs);