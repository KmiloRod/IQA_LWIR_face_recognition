ExecutaSilvio('in', 'out', false)

% ExecutaSilvio('../../Original/UND/train', '../../Segmented/Method2/UND/train', false)
% ExecutaSilvio('../../Original/UND/test', '../../Segmented/Method2/UND/test', false)
% ExecutaSilvio('../../Original/UND/allTest', '../../Segmented/Method2/UND/allTest', false)
% 
% ExecutaSilvio('../../Original/Terravic/train', '../../Segmented/Method2/Terravic/train', false)
% ExecutaSilvio('../../Original/Terravic/test', '../../Segmented/Method2/Terravic/test', false)
% ExecutaSilvio('../../Original/Terravic/allTest', '../../Segmented/Method2/Terravic/allTest', false)
% 
% ExecutaSilvio('../../Original/IRIS/train', '../../Segmented/Method2/IRIS/train', false)
% ExecutaSilvio('../../Original/IRIS/test', '../../Segmented/Method2/IRIS/test', false)
% ExecutaSilvio('../../Original/IRIS/allTest', '../../Segmented/Method2/IRIS/allTest', false)
% 
% ExecutaSilvio('../../Original/FSU/train', '../../Segmented/Method2/FSU/train', false)
% ExecutaSilvio('../../Original/FSU/test', '../../Segmented/Method2/FSU/test', false)
% ExecutaSilvio('../../Original/FSU/allTest', '../../Segmented/Method2/FSU/allTest', false)


% [FP FN ERROR1 ERROR2] = evaluate('FSU/TestSegmented', '../Segmentation/Teste_ROI_Ellipse_Edge_Fecho/FSU/Test_Segmented');
% fprintf('FSUGrey: FP = %.6f FN = %.6f Error1 = %.6f Error2 = %.6f\n', FP, FN, ERROR1, ERROR2)

% [FP FN ERROR1 ERROR2] = evaluate('UND/ir_Manual_test_Segmented', '../Segmentation/Teste_ROI_Ellipse_Edge_Fecho/UND/test_UND_Segmented');
% fprintf('UND: FP = %.6f FN = %.6f Error1 = %.6f Error2 = %.6f\n', FP, FN, ERROR1, ERROR2)
% 
% [FP FN ERROR1 ERROR2] = evaluate('Terravic/TestSmallSegmented', '../Segmentation/Teste_ROI_Ellipse_Edge_Fecho/Terravic/test_Terravic_Segmented');
% fprintf('Terravic: FP = %.6f FN = %.6f Error1 = %.6f Error2 = %.6f\n', FP, FN, ERROR1, ERROR2)
% 
% [FP FN ERROR1 ERROR2] = evaluate('IRIS/TestSmallSegmented', '../Segmentation/Teste_ROI_Ellipse_Edge_Fecho/IRIS/test_IRIS_Segmented');
% fprintf('IRIS: FP = %.6f FN = %.6f Error1 = %.6f Error2 = %.6f\n', FP, FN, ERROR1, ERROR2)
