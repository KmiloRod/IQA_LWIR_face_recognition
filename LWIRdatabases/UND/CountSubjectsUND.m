function [count,SubjectNamesArray] = CountSubjectsUND(show_names)
%COUNTSUBJECTSUND Counts the number of subjects represented in the images
%in the current folder, belonging the the UND thermal face database.
%
% [COUNT, SUBJECTNAMESARRAY] = COUNTSUBJECTSUND(SHOW_NAMES) returns in the
% scalar COUNT the number of different subjects included in the current
% folder, and a cell array SUBJECTNAMESARRAY containing their
% identification strings. If SHOW_NAMES equals 1, the names are also shown
% in the command window.
%
% (c) 2015, 2016 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%========================================================================

DirInfo = dir;

n = size(DirInfo,1);
PreviousName = string;
count = 0;

for i = 3:n
    name = DirInfo(i).name;
    if strcmp(name(end-4:end),'.tiff') || strcmp(name(end-3:end),'.bmp') || strcmp(name(end-3:end),'.jpg')
        SubjectName = name(1:5);
        if ~strcmp(SubjectName,PreviousName)
            count = count + 1;
            SubjectNamesArray{count} = SubjectName;
        end
        PreviousName = SubjectName;
    end
end

if show_names
    SubjectNamesArray
end