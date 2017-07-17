function TSResults = ProcessTSScores(TS_Gen_Measures,TS_Imp_Measures,SubjectIndex,Thresholds)
%PROCESSTSSCORES allows to test several threshold with previously
% calculated similarity scores for specific subsets Test and TestN, using
% the TST-based method for LWIR face recognition.
%
% The function receives as inputs the genuine scores TS_GEN_MEASURES, the
% imposter scores TS_IMP_MEASURES, a vector of subject indexes
% SUBJECTINDEX, and a vector of values of thresholds (THRESHOLDS).
%
% The function returns a TSRESULTS matrix containing the Recognition and
% False Alarm rates for identification and verification performance
% evaluation, and plots the corresponding ROC and CMC.
%
% (c) 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%========================================================================

numThresholds = length(Thresholds);
NumProbesGen = size(TS_Gen_Measures,2);
NumProbesImp = size(TS_Imp_Measures,2);
numSubjects = size(TS_Gen_Measures,1);

[Ranked_gen_scores, Rank_gen] = sort(TS_Gen_Measures,'descend');
[Ranked_imp_scores, ~] = sort(TS_Imp_Measures,'descend');

Ranks = repmat(SubjectIndex,numSubjects,1) == Rank_gen;
only_ranked = Ranked_gen_scores.*Ranks;

for t = 1:numThresholds
    threshold = Thresholds(t);

    % Genuine Scores
    for k = 1:numSubjects
        idRecognitionRate(k,t) = sum(sum((only_ranked(1:k,:) >= threshold)))/NumProbesGen;
    end
    verificationRate(t) = sum(sum((Ranked_gen_scores >= threshold) & Ranks))/NumProbesGen;
    
    % Impostor Scores
    idFalseAlarmRate(t) = sum(Ranked_imp_scores(1,:) >= threshold)/NumProbesImp;
    veFalseAlarmRate(t) = sum(sum(Ranked_imp_scores >= threshold))/(NumProbesImp*numSubjects);
end

% Genuine Scores
idFalseAlarmRates = idFalseAlarmRate;
veFalseAlarmRates = veFalseAlarmRate;

% Impostor Scores
idTPRates = idRecognitionRate;
verifRates = verificationRate;

TSResults = [Thresholds; idFalseAlarmRates; idTPRates; nan(1,length(Thresholds)); Thresholds; verifRates; veFalseAlarmRates];
csvwrite('TSResults.csv',TSResults);

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
