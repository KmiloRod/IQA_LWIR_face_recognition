function ts_pos = TSSizesExtract(folder_name, Database)
%RESULTSCW_ALL Extract the size of the thermal signatures of LWIR facial
% images in a folder.
% [TS_POS] = RESULTSCW_ALL(FOLDER_NAME, DATABASE)
% receives as inputs a directory name string FOLDER_NAME and a DATABASE to
% use. The function extracts the bounding boxes of the thermal signatures
% from all the images within the folder FOLDER_NAME belonging to the
% data set DATABASE.
%
% The coordinates of the bounding box superior left and inferior right
% corners are stored in the cell matrix TS_POS along with the image name
% and the thermal signature as a vector.
%
% DATABASE = String belonging to {UND, PUJ, FONE}
%
% (c) 2016, 2017 Camilo Rodríguez, Pontificia Universidad Javeriana
%     Cali, Colombia
%========================================================================

tic

DirInfo = dir(folder_name);
oldFolder = cd(folder_name);
n = size(DirInfo,1);
ts_pos = cell(n-2,3);
k = 1;

for i = 3:n
    name = DirInfo(i).name;
    if strcmp(name(end-4:end),'.tiff') || strcmp(name(end-3:end),'.bmp') || strcmp(name(end-3:end),'.jpg')
        vascIm = vascularExt(name, 0, Database);
        [rs, cs] = find(vascIm);
        r_min = min(rs); r_max = max(rs);
        c_min = min(cs); c_max = max(cs);
        vasc_pixels = vascIm(r_min:r_max, c_min:c_max);
        vasc_pixels = reshape(vasc_pixels', [numel(vasc_pixels), 1]);
        ts_pos{k,1} = name(1:end-5);
        ts_pos{k,2} = [r_min r_max c_min c_max];
        ts_pos{k,3} = vasc_pixels;
        k = k + 1;
    else
        ts_pos(k,:) = [];
    end
end

cd(oldFolder);
toc