# PUJ-T360 Thermal Face Images Database

The images in this folder were acquired in the Pontificia Universidad Javeriana Seccional Cali, Colombia, during from 2015 to 2016, with a FLIR T360 Long Wave Infrared camera.

Image size is 320 x 240 pixels. The database include variations on illumination, expression and pose. The camera saves the images in JPEG format by default; hence, the 'pristine' images exhibit mild blocking artifacts.

All images in the data-set are contrast adjusted, segmented from background, and registered to a global reference image. Raw versions (without registration and segmentation) of the database as well as visible images from the same individuals can be found at http://bit.ly/PUJ_IR_db.

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

* **CountSubjectsPUJ**: Function used to count the number of individuals photographed in the LWIR images in the current folder.
* **PUJDatabaseTSSave**: Script used to generate the TST of each subject in the Gallery sub-set, and save them in the 'Signatures' folder.

##
Camilo Rodríguez, July 2017

Contact: camilo.g.rodriguezpulecio@ieee.org
