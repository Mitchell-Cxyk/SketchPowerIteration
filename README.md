## Important: Path requirement
 **First create a dir(Your dir), then clone this Repository in your dir. Download the Requirement also in your dir.**


## Requirement
The data generating may cost much time. You can **download the matrix data .mat** file from Google Drive https://drive.google.com/drive/folders/1QcM8k7p_j7uL_TbbHpo3nTLYNxWHhyCQ?usp=drive_link . Put the NIST20000.mat into the **realdata/NIST/** folder. Put the dataMatrix.mat into the **realdata/Climate/** folder. Or you can download data from following source:
1. Data: Please download the dataset NIST Specical database 19 from https://s3.amazonaws.com/nist-srd/SD19/by_class.zip, which is seen in https://www.nist.gov/srd/nist-special-database-19 to find more information.
2. Data: Please download the dataset from https://downloads.psl.noaa.gov/Datasets/ncep.reanalysis/surface/, which is seen in website https://psl.noaa.gov/data/gridded/data.ncep.reanalysis.html to find detailed information.

# All Folder structure

**Please ensure the folder structure as follows:**
 ```plaintext
Folder/
├── ** dataset (Download as readme.md) **/
│   ├── by_class/
│   └── surface/
└── ** SketchPowerIteration (This Repository) **/
    ├── LowRankApproximation
    ├── RunExamples
    ├── SimpleTest
    ├── StreamingThreeSketch
    ├── TYUC17SPI
    │   └── data
    ├── TestMatricesTest
    │   ├── data
    │   └── figure
    ├── Tools
    ├── VerifyPerformance
    │   └── TYUC17withSPSOracle
    │       └── figure
    │           └── SketchSingularValue
                |__ qFigure
    ├── realdata
    │   ├── Climate
    │   │   ├── data
    │   │   ├── dataNewPara
    │   │   ├── figureNewPara
    │   │   ├── geoFigure
    │   │   └── worldmap
    │   └── NIST
    │       ├── data
    │       └── figure
    │           ├── NISTSingularValue
    │           └── NISTSingularVector
    │               ├── SingularVectorError
    │               └── SingularVectorVis
    ├── testAsTYUC17
    ├── testStreamingSPI
    │   ├── data
    │   └── figure
    └── testYinC
        ├── data
        └── figure
            └── W1
```
The code in this Repository can mkdir automatically. If the path error "not exist folder", please check the folder to be the same as above.

## Run RunExamples

1. You can run the **RunTests.m** to run all tests. However, it may **costs much time**. You can run the m files in **RunExamples** Folder. Run the scripts RunExample 1-5 .m files to get the results in main paper. Run the scripts RunExampleSM 1-4 .m files to get the results in Supplement Materials.
2. All data and figure is stored in figure/ or data/ in the corresponding subfolders. One can get more information out of the paper.
3. Reading the RunExample m files can help to find the corresponding subfolder for each example.
4. Run paintFigs(*).m to watch the results. The first figure is to show some important tips. Then you can press any key to watch the next figure when figures are shown.
5. The data generating may cost much time. You can **download the matrix data .mat** file from Google Drive https://drive.google.com/drive/folders/1QcM8k7p_j7uL_TbbHpo3nTLYNxWHhyCQ?usp=drive_link . Put the NIST20000.mat into the **realdata/NIST/** folder. Put the dataMatrix.mat into the **realdata/Climate/** folder.
