%RESULTSPARTS Returns Ranked results from a thermal face recognition
% algorithm execution in a database with previously registered images.
% It returns the ranked recognition accuracy.
%
% (c) 2016 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%=========================================================================

function TotalRank = ResultsParTS(dirName,Database,mode,RecognitionThreshold,param,parValue)

DirInfo = dir(dirName);
n = size(DirInfo,1);
cd (dirName);

if strcmp(Database,'UND')
    Subjects = {'02463';'04200';'04202';'04203';'04204';'04206';'04207';...
        '04209';'04210';'04211';'04212';'04213';'04215';'04216';'04218';...
        '04219';'04220';'04222';'04226';'04228';'04230';'04234';'04235';...
        '04236';'04239';'04241';'04244';'04249';'04250';'04251';'04253';...
        '04254';'04255';'04257';'04260';'04262';'04263';'04266';'04270';...
        '04273';'04275'}; % UND Database (41 subjects)        
elseif strcmp(Database,'PUJ')
    Subjects = {'S01';'S02';'S03';'S04';'S05';'S06';'S07';'S08';'S09';'S10';...
        'S11';'S12';'S13';'S14';'S15';'S16';'S17';'S18';'S19';'S20'}; % PUJ T360 Database
elseif strcmp(Database,'FONE')    
    Subjects = {'S01';'S02';'S03';'S04';'S05';'S06';'S07';'S08';'S09';'S10';...
        'S12';'S14';'S16';'S18';'S20';'S22';'S24';'S26';'S28';'S29';'S31';...
        'S33';'S35';'S37';'S39'};   % PUJ F-ONE Database    
end
    
TotalRank = zeros(1,n-2);
NonRecognized = 0;
FalseAlarm = 0;
NumProbes = 0;
k = 1;

for i=3:n
    name = DirInfo(i).name;
    if strcmp(name(end-4:end),'.tiff') || strcmp(name(end-3:end),'.bmp') || strcmp(name(end-3:end),'.jpg')
        NumProbes = NumProbes + 1;
        [B, Rank] = sort(ThermalSimilarityDatabasePar(name,Database,mode,param,parValue),'descend');
        if B(1)<RecognitionThreshold
            TotalRank(k) = [];
            NonRecognized = NonRecognized + 1;
            continue;
        end
        SubjectIndex = NaN;
        for j = 1:size(Subjects,1)
            if strfind(name,Subjects{j})
                SubjectIndex = j;
                break;
            end
        end
        if ~isnan(SubjectIndex)
            TotalRank(k) = find(Rank==SubjectIndex);
            k = k + 1;
        else
            TotalRank(k) = [];
            FalseAlarm = FalseAlarm + 1;
        end
    else
        TotalRank(k) = [];
    end
end

cd ..