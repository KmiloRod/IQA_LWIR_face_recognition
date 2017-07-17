# UND Thermal Face Images Database

The images in this folder were extracted and modified from the Collection X1 of Long Wave Infrared facial images, acquired by the Computer Vision Research Laboratory at University of Notre-Dame in Indiana, USA, from 2002 to 2004. More information about this collection can be found in http://sites.google.com/a/nd.edu/public-cvrl/data-sets.

Image size is 312 x 239 pixels. The database include variations on illumination, expression and time-lapse. The images were not corrected for non-uniformity during acquisition; hence, the 'pristine' images exhibit the grid-like pattern characteristic of non-uniformity defects of the thermal sensors.

All images in the data-set are contrast adjusted, segmented from background, and registered to a global reference image.

## Description of contents

### Folders

* **Pristine**: Original versions of the Gallery (G), Probe (P_G), ProbeN (P_N), ProbeCW (P_CW), and ProbeNCW (P_N_CW) sub-sets used for testing the face recognition algorithms.
* **AWNdist**: Distorted versions of the G, P_G, P_N, P_CW, P_N_CW sub-sets, with three severity levels of artificial additive white gaussian noise applied.
* **BLURdist**: Distorted versions of the G, P_G, P_N, P_CW, P_N_CW sub-sets, with three severity levels of artificial gaussian blur applied.
* **JPGdist**: Distorted versions of the G, P_G, P_N, P_CW, P_N_CW sub-sets, with three quality levels of JPG compression applied.
* **NUdist**: Distorted versions of the G, P_G, P_N, P_CW, P_N_CW sub-sets, with three severity levels of artificial non-uniformity noise applied.
* **Classifier**: Contains the pristine and distorted versions of the Test and TestN subsets used for testing the NSS-enhanced TST method of face recognition. It also includes the sub-set used for training the SVM classifiers.
* **Signatures**: Contains the skeletonized Thermal Signature Templates (TST) of each individual represented in the G and P_G sub-sets.

### Source Code

* **CountSubjectsUND**: Function used to count the number of individuals photographed in the LWIR images in the current folder.
* **UNDDatabaseTSSave**: Script used to generate the TST of each subject in the Gallery sub-set, and save them in the 'Signatures' folder.

##
Camilo Rodríguez, July 2017

Contact: camilo.g.rodriguezpulecio@ieee.org
