# Making Infrared Face Recognition Robust Against Perceptual Image Quality Degradation

Authors: Camilo Rodríguez, Hernán Benítez and Alan Bovik

Contact: camilo.g.rodriguezpulecio@ieee.org

## Synopsis

This is the implementation in Matlab of the Long Wave Infrared (LWIR) face recognition schemes presented in:

"Making Infrared Face Recognition Robust Against Perceptual Image Quality Degradation", C. G. Rodríguez Pulecio, H. D. Benítez Restrepo, A. C. Bovik.

The paper proposes two LWIR face recognition strategies involving Image Quality Assessment (IQA) for improving the recognition accuracy. The first approach is based on Thermal Signature Templates (TST) and enhanced with Natural Scene Statistics (NSS) features. The second framework uses the Complex Wavelet Structural Similarity Index (CW-SSIM) to match LWIR facial images to the subjects identities.

## Dependencies

This software was developed in MATLAB R2016b (64 bits) in Mac OS Sierra 10.12.5. It should work in Matlab from version R2014a, but we recommend at least R2016b version. The code requires the Matlab Image Processing and Statistics and Machine Learning Toolboxes. The Parallel Computing Toolbox is recommended for some functions. In addition to Mac OS, the functions have been tested on Windows 7 and 10. They should work on other operating systems as well. 

Our NSS features estimation slightly modifies the implementation in Matlab by Goodall et al. The original version of this software is available at http://live.ece.utexas.edu/research/IR/index.htm. For more information, please refer to the paper: T. Goodall, A. C. Bovik, and Nicholas G. Paulter Jr., "Tasking on Natural Statistics of Infrared Images", IEEE Transactions on Image Processing, vol. 25, no. 1, pp 65-79, Jan 2016.

For calculation of the IQA metrics, the code requires the "matlabPyrTools" package developed by Eero Simoncelli, which is included in the folder './IQA/matlabPyrTools/'. We recommend recompiling the mex versions of the tools for your operating system and Matlab version, running the ```compilePyrTools``` script in the 'MEX' sub-folder. Further information about this package can be found at http://www.cns.nyu.edu/~lcv/software.php.

In addition to our own LWIR image segmentation scheme, we use an implementation of the approach by Filipe and Alexandre, which is also provided in the folder './Segmentation'. The method is described in the paper: Silvio Filipe and Luís A. Alexandre, “Algorithms for Invariant Long-Wave Infrared Face Segmentation: Evaluation and Comparison” Pattern Analysis and Applications, vol. 17, Issue 4, pp. 823-837.

## Installation
Download or clone the complete repository folder to a working directory of Matlab, and call the functions from the Matlab command window. All folders and sub-folders must be added to the Matlab path.

## LWIR Facial Images Sources
Three LWIR face image databases are included, which were used for obtaining the results reported in our paper (UND, PUJ-T360, and PUJ-FONE). They are in the 'LWIRdatabases' folder, organized in the file structure used to the tests we performed, and already segmented and registered. The sub-folders 'Classifier' in each data set, contain the sub-sets used for testing the TST-method enhanced with NSS features. The distorted versions of all the images are provided as well, with four different distortions (additive white gaussian noise, gaussian blur, JPEG compression and non-uniformity). Please, refer to the paper referred in the Synopsis for further details on the databases.

## Tests

There are three main Matlab functions for evaluating performance of the proposed LWIR face recognition methods:

- ```ResultsIdAndVerifTS_All```: This function tests the TST-based method, without the NSS features added.
- ```ResultsIdAndVerifTS_Class138_All```: This function tests the TST-based method, with the NSS features added.
- ```ResultsCW_All```: This function tests the method based on the CW-SSIM index.

These functions must be called from the location containing the folders with the probe images to be tested. The functions return a matrix containing performance metrics for identification and verifications modes, and plot the ROC and CMC curves for the thresholds values tested. They receive as inputs the Distortion string, Database identification string, and a vector of Threshold values. See the help and comments in each function source file for detailed information on how to use it.

### Usage examples

1. Testing the TST method without using NSS features, on pristine images from the UND database, with three values of threshold (0.4, 0.6 and 0.9):

	```TSResults = ResultsIdAndVerifTS__All('Pristine','UND',[0.4 0.6 0.9]);```

2. Testing the TST method enhanced with NSS features on images from the PUJ-FONE database affected by the second severity level of blur, varying the similarity threshold from 0.2 to 0.8:

	```TSResults = ResultsIdAndVerifTS_Class138_All('Blur2','FONE',0.2:0.005:0.8);```

3. Testing the CW-SSIM method on images from the PUJ-T360 database affected by non-uniformity, with threshold values from an array named 'Tresh_array':

	```TSResults = ResultsCW_All('NU','PUJ',Thresh_array);```

## Auxiliary Functions

Here is a list of other useful functions and scripts provided:

- ```TrainingPreprocessing```: Prepares the NSS features for training the SVM classifier of the desired database.
- ```TSSizesExtract```: Extract the size of the bounding box enclosing the thermal signatures of LWIR facial images in a folder.
- ```CWSimilarityImageSet```: Calculates similarity measures between a thermal face image and all the thermal images from an image set, using the CW-SSIM similarity index.
- ```AWNdist```, ```BLURdist```, ```JPEGdist``` and ```NUdist```: These functions add artificial distortions to the images in a directory, with the desired input parameters governing the severity level of the distortion.
- ```ProcessTSScores``` and ```ProcessCWScores```: allow to test several threshold with previously calculated similarity scores for specific subsets P_G and P_N, using the TST-based or CW-SSIM based methods for LWIR face recognition, respectively.
- ```ParamRank``` and ```ParamSurfaceGen```: can be used to analyze the dependence of the recognition accuracy in the TST method on the values of parameters \kappa and \rho.
- ```showOverlappedTS```: shows a thermal signature and a TST overlapped in the same figure.
- Folders 'Registration' and 'Segmentation' provide the code used for aligning the faces in the images, and segmenting them from the background respectively.

## Contributors

* **Camilo Rodríguez** - TST and CW-SSIM method implementations, SVM classifier, databases adjustment and ordering, tests and comments - [KmiloRod](http://github.com/KmiloRod)
* **Hernán Benítez** - Registration and segmentation methods, TS extraction process adjustments and testing.
* **David Moreno** - NSS features extraction adaptation - [ujemd](http://github.com/ujemd)

## Acknowledgments

Thanks to the [Laboratory for Image & Video Engineering (LIVE)](http://live.ece.utexas.edu) team from The University of Texas at Austin, TX, USA, for providing the initial implementations of the NSS and CW-SSIM metrics implementations.

Thanks to [Silvio Filipe](http://socia-lab.di.ubi.pt/~silvio/) from the University of Beira Interior, Covilhã, Portugal, for his code for segmenting LWIR facial images.

