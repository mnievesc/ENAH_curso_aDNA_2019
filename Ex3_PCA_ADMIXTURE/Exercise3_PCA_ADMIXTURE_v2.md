# Curso de Paleogenómica y Antropología ENAH Mayo 2019

## __Exercise 3: Plotting and interpreting PCA and ADMIXTURE analyses__

**Author:** Maria Nieves Colón (maria.nieves@cinvestav.mx / mnievesc@asu.edu)

---
### Learning Objectives:
In this tutorial we will conduct analyses of ancient DNA genotypes to test the "Paleoamerican"model. We will replicate analyses conducted in  _Raghavan et al. 2015. "Genomic evidence for the Pleistocene and recent population history of Native Americans". Science 349 (6250): aab3884_. Specifically, we will use Rstudio to plot the results of principal components (PCA) and ADMIXTURE analyses on genotypes from ancient and present-day human populations. At the end of this exercise students should:
* Understand how to use multivariate and unsupervised approaches to make inferences and test hypotheses about human population history.
* Become familiar with input and output files from programs such as plink, smartpca and ADMIXTURE, which are commonly used to perform analyses with ancient DNA data.
* Understand how to choose comparative or reference populations for analyses.
* Be able to interpret PCA and ADMIXTURE plots.
* Become familiar with plotting in Rstudio.


&nbsp;

### Necessary software:
* Rstudio (https://www.rstudio.com/)
  * R libraries: ggplot2, RColorBrewer


&nbsp;
### Input files:
#### 1. Plink files containing merged ancient genotypes with comparative population data
```
Ancient+HGDP.bed
Ancient+HGDP.bim
Ancient+HGDP.fam
```
For this exercise we will work with publicly available ancient DNA data downloaded from the Reich Lab website: https://reich.hms.harvard.edu/downloadable-genotypes-present-day-and-ancient-dna-data-compiled-published-papers. This dataset includes merged autosomal genotypes for both ancient and present-day human populations. The data was generated on the Affymetrix Human Origins array (for modern samples) or the 1240K capture (for ancient samples), and includes genotypes for 597,573 autosomal positions. The dataset on the website includes genotypes for over 7,000 individuals. Today we we will work with a subset of 892 genotypes which includes 19 ancient individuals and 873 present-day individuals from the Human Genome Diversity Panel (HGDP). These were transformed to plink format using the CONVERTF module within the EIGENSTRAT suite (https://github.com/DReichLab/EIG/tree/master/EIGENSTRAT) and plink 1.9 (https://www.cog-genomics.org/plink2) and were used for performing ADMIXTURE and smartpca analyses.


#### 2. Popinfo file
```
Ancient+HGDP.popinfo.text
```
Text-delimited file listing metadata for our working dataset, including individual and population IDs, country of origin, and labels for PCA and ADMIXTURE plots.


#### 3. Smartpca files
```
Ancient+HGDP.eval
Ancient+HGDP.evec
Ancient+HGDP.snp
Ancient+HGDP.ind
Ancient+HGDP.geno
Ancient+HGDP.smartpca.par
```
Smartpca was run with command: `smartpca -p Ancient+HGDP.smartpca.par`. PCA eigenvectors were constructed with modern populations and the ancient individuals were projected on top using hte `lsqproject` option.
Input files: EIGENSTRAT format files `.snp`, `.ind`, and `.geno`. Generated with CONVERTF module. The `.par` file specifies parameters for running smartpca. The `poplist`files lists all the populations used to construct the PCA eigenvectors.
Output files: Smartpca output `.evec` and `.eval` files.


#### 4. ADMIXTURE files
```
Ancient+HGDP.LDpruned.bed
Ancient+HGDP.LDpruned.bim
Ancient+HGDP.LDpruned.fam

get_admixture.sh

Ancient+HGDP.LDpruned.2.Q
Ancient+HGDP.LDpruned.2.P
Ancient+HGDP.LDpruned.log2.out
.
.
.
Ancient+HGDP.LDpruned.10.Q
Ancient+HGDP.LDpruned.10.P
Ancient+HGDP.LDpruned.log10.out

Ancient+HGDP.Kcomparison.txt
```
ADMIXTURE analysis is performed for K values 2-10 after pruning the dataset for linkage disequilibrium (LD).
Input files: Plink format files after LD pruning . The script used to prune the dataset and run ADMIXTURE is `get_admixture.sh`.
Output files: ADMIXTURE output, one file per value of K, `.Q` files list the estimated ancestry proportions, `.P`files list allele frequencies, .`log` files from ADMIXTURE run and `Kcomparison.txt` lists the cross validation error per run of K.



### 5. Rscripts
```
get_smartPCA_plot.R
get_admixture_plot.R
```
Scripts for generating PCA and ADMIXTURE plots.

&nbsp;


---

### 3.1 The research question: What do we want to know?
Any ancient DNA study must begin with a **clearly defined research question**. The question will guide us in formulating and testing hypotheses, designing sampling strategies and choosing an analytical framework. In this exercise, we will analyze ancient DNA genotypes to revisit a very old question in the anthropology of the Americas: the "Paleoamerican" model. We will replicate analyses conducted in _Raghavan et al. 2015. "Genomic evidence for the Pleistocene and recent population history of Native Americans". Science 349 (6250): aab3884._. In this study the researchers used ancient DNA to test if Pleistocene Native American peoples were more closely related to present-day Australo-Melanesians than to today's Indigenous American communities.

&nbsp;

### Some background
The Paleoamerican model proposes that the Americas were peopled in two major migration waves of distinct peoples. It is based on several findings of Late Pleistocene human skeletal remains across the Americas with cranial morphologies that are distinctive from those of present-day Native Americans. Examples of individuals attributed to this very early migration include the 12,000 year old skeleton of Luzia found in Lagoa Santa in Brazil, and Pleistocene peoples excavated in Pericúes and Fuego-Patagonian archaeological contexts in Mexico, Argentina and Chile. Based on morphological analyses, these individuals have been hypothesized to represent a very early migration of peoples from Asia who were closely related to the ancestors of present-day Oceanian communities, specifically, Australo-Melanesians.


&nbsp;
### Testing the Paleoamerican model
Raghavan et al. (2015) sequenced the genomes of 17 putative ancient "Paleoamerican" individuals. These included:
- 6 individuals from the Piedra Gorda cave in Baja California, Mexico, attributed to the Pericúes culture.
- 11 individuals attributed to the Yaghan (Yamaná), Kawskar (Alacalúf) and Selknam (Ona) cultures from several archaeological contexts in Tierra del Fuego, Patagonia and the Chilean Pacific coast.
Additionally, they also sequenced the genomes of two ancient Tarahumara mummies representing ancient Native American peoples with skull morphology that are not associated to the Paleoamerican migration.

In this exercise, we will use the data generated in the Raghavan et al. (2015) study to replicate their test of the Paleoamerican model.  Specifically we want to answer the following research questions:
1. Are the Pericúes and Fuego-Patagonians genetically distinct from other Native American groups?
2. Do the Pericúes and Fuego-Patagonians fall within the known genetic variation of present-day Oceanian populations?

&nbsp;
**Before we start, answer the following questions:**
* Formulate a null and alternative hypothesis for each of the stated research questions.
* How would you design an ancient DNA study to test each of your hypotheses?
* What reference populations would you include in comparative analyses?
* Predict which ancient DNA findings would provide support for your alternative hypothesis. Specifically, what do you expect to see in your PCA and ADMIXTURE plots?


&nbsp;
---

### 3.2 Generating and interpreting PCA plots.
PCA is a multivariate analysis method which summarizes the variation present in our data. By plotting the eigenvectors, we can visualize genetic distance between populations. Although the analysis does not consider pre-defined group or individual labels, in this plot, we have grouped the present-day populations according to the classification used by the HGDP, into seven global regions. See classification here: https://en.wikipedia.org/wiki/Human_Genome_Diversity_Project.

Open Rstudio on your computer. Use the bottom right window to navigate to the folder for exercise 3. Set this as your Working Directory by clicking on the **More** button and selecting the **Set as Working Directory** option.

![alt text](https://github.com/mnievesc/ENAH_curso_aDNA_2019/blob/master/Ex3_PCA_ADMIXTURE/images/Screen%20Shot%202019-04-16%20at%205.23.15%20PM.png)

Alternatively, you can set the working directory using the console by providing the path directly. In this example my files are stored on my Desktop:
```
setwd("Desktop/ENAH_curso_aDNA_2019/Ex3_PCA_ADMIXTURE/")
```
&nbsp;

Within the Rstudio environment, click on script `get_smartPCA_plot.R`. This script reads in the output from smartpca (`.evec` and `.eval` files) and combines it with the metainformation contained in the `popinfo.txt` and `.fam`files.

To run the full script without making any changes you can click on the **Source** button on the top right menu or you can select the full block of code and click on **Run**. If you want to explore what the commands do, you can select blocks of code and run them one by one with this button as well.

![alt text](https://github.com/mnievesc/ENAH_curso_aDNA_2019/blob/master/Ex3_PCA_ADMIXTURE/images/Screen%20Shot%202019-04-16%20at%205.46.29%20PM.png)


This script will output a PDF file `Ancient+HGDP.smartpca.pdf` with three pages, displaying plots for PC1 vs 2, PC 1 vs 3 and PC 2 vs 3.

&nbsp;
**Examine the PCA plots and answer the following questions:**
* How much variation is explained in the top three principal components?
* How do populations separate in PC space?
* Where to the ancient individuals fall in this plot? Which global populations do they cluster with?
* Do the ancient Tarahumara individuals cluster separately from the putative Paleoamericans?
* How do you think this analysis is influenced by our classification



&nbsp;
---

### 3.3 Generating and interpreting ADMIXTURE plots.
Repeat the same procedure as above with the `get_admixture_plot.R`. script. You should obtain three PDF files as output.

#### Choosing the correct value for K
ADMIXTURE is an example of unsupervised analyses which assigns individual genotypes to one or several pre-defined ancestry components (K value). In this case, we ran ADMIXTURE for nine models, K=2 to K=10. In other words, we ran nine models, assuming that the individuals in our dataset could have between 2 and 10 ancestry components. How do we choose which value of K is the best estimation?

Open the first file `Ancient+HGDP.ADMIXTURE.CVerror.pdf`. This plot displays the cross-validation (CV) error associated with each K estimate. (You can also see the raw CV error in the ADMIXTURE log files within the output folder.)

&nbsp;
**Examine the CV plot and answer the following questions:**
* Which estimate of K has the lowest CV error?


&nbsp;

Next, lets open the remaining three PDF files to examine the ADMIXTURE barplots. Remember that each plot actually composed of individual bars. Every bar represents an individual, and the colors represent the proportions of estimated ancestry that correspond to each component of K. As before, this analysis does not consider pre-defined individual or group labels. But in the plot we have grouped the present-day populations according to the HGDP classification. Each region is divided by white space. The ancient Tarahumara, Pericúes and FuegoPatagonian individuals are placed at the far right end of the plot.

&nbsp;
**Examine the barplots and answer the following questions:**
* Which global populations do the ancient Pericúes and FuegoPatagonians share ancestry with?
* What inferences can you draw about the population structure of the ancient Pericúes and FuegoPatagonians?
* What about the ancient Tarahumara?
* Can you see structure within populations from each of the seven HGDP global regions? Why do you think this is the case?
* How does the selection of reference populations affect this analysis, especially as pertains to the optimal K value?
* How does the classification we used influence our analysis?
* Would you choose different reference populations for this analysis? If so, which ones.

_NOTE:_ Remember that ADMIXTURE analyses will always give us an estimate, regardless of wether or not the true population history is reflected in the predetermined K values we have tested for.


---

### Bringing it all together
After completing all steps, answer the following questions:
* Did the results of the PCA and ADMIXTURE analysis support your alternative hypotheses?
* What can you conclude about the population history of the ancient Pericúes and FuegoPatagonians?
* Does your analysis support the expectations of the Paleoamerican model?
* What limitations do you see in these analyses?
* What other analyses or procedures would you like to conduct to have more confidence in your conclusions?
* Imagine that we would like to extend our study to examine which present-day Native American populations are more closely related to the Pericúes and Fuego-Patagonians. How would you do this? What would be your study design? Which comparative populations would you include in yoru analyses?


---

### References for further study:
1. Alexander, D.H., Novembre, J. and K. Lange. 2009. "Fast model-based estiamtion of ancestry in unrelated individuals". Genome Research 19(9):1655-1664.

2. Lawson, D.J., van Dorp, L., and D. Falush. 2018. "A tutorial on how not to over-interpret STRUCTURE and ADMIXTURE bar plots". Nature Communications 9(1):s41467-018-05257-7.

3. Li, J.Z., Absher, D.M., Tang, H., Southwick, H.M., Casto, A.M., Ramachandran, S., Cann, H.M., Barsh, G.S., Feldman, M., Cavalli-Sforza, L.L. and R. M. Myers. 2008. Worldwide human relationships inferred from genome-wide patterns of variation. Science 22(319):1100-1104.

4. Patterson, N., Price, A.L., and D. Reich. 2006. "Population structure and eigenanalysis.". Plos Genetics 2(12): e190.

5. Raghavan et al. 2015. "Genomic evidence for the Pleistocene and recent population history of Native Americans". Science 349 (6250): aab3884.

6. Stoneking, M. and J. Krause. "Learning about human population history from ancient and modern genomes" Nature Reviews Genetics 12: 603-614.
