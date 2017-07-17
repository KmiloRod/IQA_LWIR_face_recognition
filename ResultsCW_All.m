function CWResults = ResultsCW_All(Distortion,Database,Thresholds)
%RESULTSCW_ALL Tests the CW-SSIM LWIR face recognition algorithm on several
% threshold values.
%
% [TSResults] = RESULTSCW_ALL(Distortion, Database, Thresholds)
% receives as inputs a Distortion type, a Database to be used, and a vector
% of threshold values (Thresholds). The function performs the tests on
% the Probe and ProbeN or Test and TestN image subsets of the specified
% distortion.
%
% The function returns as output a CWResults matrix containing the
% Recognition and False Alarm rates for identification and verification
% performance evaluation, and plots the corresponding ROC and CMC.
% The last three rows of CWResults corresponds to the threshold values,
% Genuine Acceptance Rates and False Acceptance Rates respectively. The
% first row also includes the threshold values, the second row the False
% Alarm Rates and the remaining rows the Recognition Rate for each rank,
% which depends on the number of subjects in the database gallery.
%
% Database = String belonging to {UND, PUJ, FONE}
% Distortion = String belonging to {[], Pristine, AWN, BLUR, NU, JPG}
%
% (c) 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%========================================================================

tic
close all

if isempty(Distortion)
    TestFolder = 'ProbeCW';
    TestNFolder = 'ProbeNCW';
    GalleryFolder = './GalleryCW';
else
    TestFolder = strcat(Distortion, 'ProbeCW');
    TestNFolder = strcat(Distortion, 'ProbeNCW');
    GalleryFolder = '../GalleryCW';
end

disp('Calculating Genuine Scores...')
[idTPRates, ~, verifRates, ~] = idAndVerifResultsCW(TestFolder,GalleryFolder,Database,Thresholds);
disp('Calculating Impostor Scores...')
[~, idFalseAlarmRates, ~, veFalseAlarmRates] = idAndVerifResultsCW(TestNFolder,GalleryFolder,Database,Thresholds);

CWResults = [Thresholds; idFalseAlarmRates; idTPRates; nan(1,length(Thresholds)); Thresholds; verifRates; veFalseAlarmRates];
csvwrite('CWResults.csv',CWResults);

figure;
plot(veFalseAlarmRates,verifRates,'-b','LineWidth',2);
title('ROC Curve');
xlabel('False Accept Rate');
ylabel('Genuine Accept Rate');
ylim([0, 1]);
ax = gca; ax.FontSize = 14;


figure;
plot(1:size(idTPRates,1),idTPRates(:,1),'-r','LineWidth',2);
title('CMC Curve');
xlabel('Recognition Rate');
ylabel('Rank');
xlim([1, size(idTPRates,1)])
ylim([0, 1]);
ax = gca; ax.FontSize = 14;

load gong.mat
sound (y, Fs);
toc