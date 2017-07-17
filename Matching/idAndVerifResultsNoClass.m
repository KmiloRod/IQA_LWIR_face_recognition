%IDANDVERIFRESULTSNOCLASS Returns Recognition Rate and False Alarm Rate for
% identification performance, and Verification Rate and False Alarm Rate
% for verification performance for a face recognition algorithm based on
% thermal signatures.
% 
% (c) 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%=========================================================================

function [idRecognitionRate, idFalseAlarmRate, verificationRate, veFalseAlarmRate] = ...
    idAndVerifResultsNoClass(TestDir,Database,RecognitionThreshold)

if strcmp(Database,'IRIS')
    Subjects = {'Ballage';'Bernard';'Brad';'Charles';'Chris';'David';'Faysal';...
       'Gribok';'Hari';'Heo';'Justin';'Mattew';'Michael';'Nash';'Priya';...
       'Rangan';'Sangkyu';'Sarath';'Shafik';'Tak'};  % IRIS Database
elseif strcmp(Database,'UND')
    Subjects = {'02463';'04200';'04202';'04203';'04204';'04206';'04207';...
        '04209';'04210';'04211';'04212';'04213';'04215';'04216';'04218';...
        '04219';'04220';'04222';'04226';'04228';'04230';'04234';'04235';...
        '04236';'04239';'04241';'04244';'04249';'04250';'04251';'04253';...
        '04254';'04255';'04257';'04260';'04262';'04263';'04266';'04270';...
        '04273';'04275'}; % UND Database (41 subjects)    
elseif strcmp(Database,'PUJ')
    Subjects = {'S01';'S02';'S03';'S04';'S05';'S06';'S07';'S08';'S09';'S10';...
    'S11';'S12';'S13';'S14';'S15';'S16';'S17';'S18';'S19';'S20';'S28';'S29';...
    'S30';'S32';'S33'};   % PUJ T360 Database
elseif strcmp(Database,'FONE')
    Subjects = {'S01';'S02';'S03';'S04';'S05';'S06';'S07';'S08';'S09';'S10';...
        'S12';'S14';'S16';'S18';'S20';'S22';'S24';'S26';'S28';'S29';'S31';...
        'S33';'S35';'S37';'S39'};   % PUJ F-ONE Database
elseif strcmp(Database,'Mixed1')
    Subjects = {'02463';'04202';'04203';'04207';'04212';'04213';'04218';...
        '04226';'04230';'04236';'04241';'04249';'04251';'04253';'04254';...
        '04260';'04262';'04263';'04270';'04273';'Ballage';'Bernard';...
        'Brad';'Charles';'Chris';'David';'Faysal';'Gribok';'Hari';'Heo';...
        'Justin';'Mattew';'Michael';'Nash';'Priya';'Rangan';'Sangkyu';...
        'Sarath';'Shafik';'Tak'};   % Mixed IRIS-UND Database
end

testDirInfo = dir(TestDir);

wait_h = waitbar(0,'Calculating matching rates','OuterPosition',[150,400,360,80]);

numThresholds = length(RecognitionThreshold);

testFilesNames = struct2cell(testDirInfo); testFilesNames = testFilesNames(1,3:end);
n = size(testFilesNames,2);
m = size(Subjects,1);

idRecognitionRate = zeros(m, numThresholds);
idFalseAlarmRate = zeros(1, numThresholds);
verificationRate = zeros(1, numThresholds);
veFalseAlarmRate = zeros(1, numThresholds);

TS_Gen_Measures = zeros(m, n);
TS_Imp_Measures = zeros(m, n);
NumProbes = 0;
SubjectIndex = nan(1,n);
k = 1;

for i = 1:n
    name = testFilesNames{i};
    if strcmp(name(end-4:end),'.tiff') || strcmp(name(end-3:end),'.bmp') || strcmp(name(end-3:end),'.jpg')
        NumProbes = NumProbes + 1;
        
        Scores = ThermalSimilarityDatabase(name,Database,1);
        
        for j = 1:m
            if strfind(name,Subjects{j})
                SubjectIndex(k) = j;
                TS_Gen_Measures(:,k) = Scores';
                break;            
            end
        end
        
        if isnan(SubjectIndex(k))
            TS_Imp_Measures(:,k) = Scores';
        end
        k = k + 1;
    else
        TS_Gen_Measures(:,k) = [];
        TS_Imp_Measures(:,k) = [];
        SubjectIndex(k) = [];
    end
    waitbar(i/n,wait_h);
    %k
end

[Ranked_gen_scores, Rank_gen] = sort(TS_Gen_Measures,'descend');
[Ranked_imp_scores, ~] = sort(TS_Imp_Measures,'descend');

is_genuine = sum(~isnan(SubjectIndex))>0;
is_impostor = sum(isnan(SubjectIndex))>0;
if is_genuine
    Ranks = repmat(SubjectIndex,m,1) == Rank_gen;
    only_ranked = Ranked_gen_scores.*Ranks;
end


for t = 1:numThresholds
    threshold = RecognitionThreshold(t);
    if is_genuine
        for k = 1:m
            idRecognitionRate(k,t) = sum(sum((only_ranked(1:k,:) >= threshold)))/NumProbes;
        end
        verificationRate(t) = sum(sum((Ranked_gen_scores >= threshold) & Ranks))/NumProbes;
    end
    
    if is_impostor
        idFalseAlarmRate(t) = sum(Ranked_imp_scores(1,:) >= threshold)/NumProbes;
        veFalseAlarmRate(t) = sum(sum(Ranked_imp_scores >= threshold))/(NumProbes*m);
    end
end

if ~is_genuine
    idRecognitionRate = 0;
    verificationRate = 0;
    save('ImpScores','TS_Imp_Measures');
end

if ~is_impostor
    idFalseAlarmRate = 0;
    veFalseAlarmRate = 0;
    save('GenScores','TS_Gen_Measures','SubjectIndex');
end

close(wait_h);