function ExecutaSilvio(inputFolder, outputFolder, debug)

omega_i = 0;
miu_i = 0;
sigma_i = 0;

if(isdir(inputFolder) == true)
    folderPerson=dir(inputFolder);
    totalFolderPerson = length(folderPerson)-2;
    timeImage = 0.0;
    %h1 = waitbar(0,'Segmenting Images. Please wait...');    
    parfor k = 1:totalFolderPerson
    
        if((folderPerson(k+2).isdir == false)&&(~strcmp(folderPerson(k+2).name,'dados.mat'))&&(~strcmp(folderPerson(k+2).name,'.DS_Store')))

            inputImageName = [inputFolder, '/', folderPerson(k+2).name];

            j = 1;
            nameImg = ['', ''];
            while(folderPerson(k+2).name(j) ~= '.')
                nameImg = [nameImg, folderPerson(k+2).name(j)];
                j = j + 1;
            end
            outputImageName = [outputFolder, '/', nameImg, 'sg.tiff'];
            fprintf('NAME: %s\n', outputImageName);

%             fp = fopen(outputImageName, 'r');
%             if(fp == -1)
                tic;
                SegmentationSilvio(inputImageName, outputImageName, omega_i, miu_i, sigma_i, debug);
                timeImage = timeImage + toc;
%             else
%                 fclose(fp);
%             end
        end
        %waitbar(k/totalFolderPerson,h1);
    end
    timeImageMean = timeImage/double(totalFolderPerson);
else
    SegmentationSilvio(inputFolder, outputFolder, omega_i, miu_i, sigma_i, debug);
end
