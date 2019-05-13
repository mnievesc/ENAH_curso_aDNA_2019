# Curso de Paleogenómica y Antropología ENAH Mayo 2019

## __Exercise 1: Visualizing and performing QC analysis on aDNA BAM files__

**Author:** Maria Nieves Colón (maria.nieves@cinvestav.mx / mnievesc@asu.edu)

---
### Learning Objectives:
In this tutorial we will use Tablet to visualize mapped and filtered BAM files. We will also examine summary statistics about our BAM files generated in Qualimap, damage plots generated in mapDamage and contamination estimates generated with Schmutzi. At the end of this exercise students should:
* Understand what is a BAM file, and how reads are mapped to a reference genome.
* Understand concepts such as variant, coverage/read depth, read length and how they are used to analyze paleogenomics datasets.
* Evaluate authenticity of ancient DNA data.
* Understand how to integrate all of this information when choosing samples for downstream analysis.


&nbsp;

### Necessary software:
* Tablet (https://ics.hutton.ac.uk/tablet/)


&nbsp;
### Input files:
#### 1. Mapped BAM files post mapping and filtering and BAI index files. 
```
IndA.bam
IndA.bam.bai
IndB.bam
IndB.bam.bai
IndC.bam
IndC.bam.bai
rCRS.fasta
rCRS.fasta.fai
```
The BAM files contain ancient DNA read mapped to the mitochondrial human genome (mtDNA). The reads were previously quality filtered and sorted in `SAMtools`. Duplicate reads and reads with multiple mappings have also been removed. The BAI file was generated using the `samtools index` command.


#### 2. MtDNA reference genome FASTA file: `rCRS.fasta` and index `rCRS.fasta.fai`. 
The reference genome has been previously indexed using command `samtools index rCRS.fasta`.

&nbsp;


---

### 1.1 Visualizing the BAM alignment
Open the Tablet program on your computer. Click on the **Open Assembly** button. Navigate to the folder for Excercise 1 Select `IndA.bam` as your primary assembly and`rCRS.fasta` as the reference file. Click on the **Open** button at the far right end of the menu.

![alt text](https://github.com/mnievesc/ENAH_curso_aDNA_2019/blob/master/Ex1_aDNA_BAM/images/1579DB95C8386B2C35B5699613703DE5.png)

&nbsp;

Once the BAM file loads into Tablet the program will prompt you to select the contig at the far left of the screen. You should now be able to see the reads aligned to the reference.

![alt text](https://github.com/mnievesc/ENAH_curso_aDNA_2019/blob/master/Ex1_aDNA_BAM/images/563E237605B31EC40562CDF03447C999.png)

&nbsp;
You can explore the alignment with the **Zoom** and **Variants** options under the **Adjust** toolbar at the top of the screen. Once you feel comfortable navigating the alignment click on the **Jump to Base** button under the **Navigate** tooblar. Next, enter the number 6686 and Click on the **Padded Jump** button. This will take us to position 6,686 of the mtDNA genome. 

![alt text](https://github.com/mnievesc/ENAH_curso_aDNA_2019/blob/master/Ex1_aDNA_BAM/images/9DC421D15EF3B7BF51C3FB88BF56A7F6.png)

&nbsp;
**Observe the alignment and answer the following questions:**
* What is different about this position compared to the rest of the genome? 
* Place your mouse over position 6,686. What is the coverage at this position?
* Do we have sufficient read depth to call a variant at this position?
* Now, repeat these steps with the BAM files for IndB and IndC. What differences do you observe? Which alignment has the least amount of data? Which has the most?
* Do all samples have enough reads for confident variant calling?

&nbsp;


---

### 1.2 Interpreting summary statistics for the BAM alignment 
Navigate to the folder **QualimapReports**. This contains 3 PDF reports generated in Qualimap (http://qualimap.bioinfo.cipf.es/). Qualimap is an open-access application for performing QC analysis of SAM/BAM files. Each report contains statistics calculated per sample BAM. Read through the PDF file and obtain the following statistics, comparing each of our test samples:

|Sample | Number of mapped reads | Mean read length | Mean coverage | Std Dev coverage | Mean mapping quality |
|-------|-----------------|------------------|---------------|------------------|----------------------|
| IndA  |  | | | | | 
| IndB  |  || |   | |
| Ind C |  | | | | |

**Answer the following questions:**
* Which sample has the least amount of mapped reads? Which has the most? Is this consistent with what you saw in Tablet?

* Examine the **coverage histograms** included in the report. How do they differ per sample? Why is this useful information? Example for IndA:

![alt text](https://github.com/mnievesc/ENAH_curso_aDNA_2019/blob/master/Ex1_aDNA_BAM/images/B67DF7C9FE335A22798527D728F7C93C.png)

* Examine the **genome fraction coverage** plots included in the report. What is this plot telling you? How is this information different than that provided by the coverage histograms? Example for IndA:

![alt text](https://github.com/mnievesc/ENAH_curso_aDNA_2019/blob/master/Ex1_aDNA_BAM/images/61D539E70ECC70199A518211478A67DA.png)

* Which sample has the largest read length? Does this fit expectations for aDNA?
* How does coverage differ from read depth? 
* What is the difference between coverage and endogenous content?

&nbsp;

---

### 1.3 Interpreting measures of aDNA authentication: mapDamage and schmutzi reports 

&nbsp;
### Damage patterns
Navigate to the folder **mapDamageReports**. This contains 2 PDF reports per sample, both generated with mapDamage (https://ginolhac.github.io/mapDamage/) using command: `mapdamage -i IndA.bam -r rCRS.fasta`.

&nbsp;
The **Fragmisincorporation_plot** displays the patterns of C -> T and G-> A changes across the DNA fragments of a given sample. For IndA for example:

![alt text](https://github.com/mnievesc/ENAH_curso_aDNA_2019/blob/master/Ex1_aDNA_BAM/images/0E042CC1E9BE496826573C1865815FBB.png)

&nbsp;
The **Length_plot** displays the distribution of read lengths of a given sample. For IndA for example:
![alt text](https://github.com/mnievesc/ENAH_curso_aDNA_2019/blob/master/Ex1_aDNA_BAM/images/D7CCB3F7A784BFE0A67C4DDB59444C4E.png)

&nbsp;
**Examine both plots per each sample and answer the following questions:**
* What is the expected misincorporation pattern for aDNA?
* What is the expected read length distribution pattern for aDNA?
* Do all samples fit these expectations? Do any of the samples seem like they may be contaminated?

&nbsp;
### Contamination
Schmutzi (https://github.com/grenaud/schmutzi) is a program which uses Bayesian estimation to estimate mitochondrial contamination, by looking at deamination patterns alone or by comparing the test sample to a large reference database of potentially contaminant mtDNA genomes (mtDNA allele frequencies to be exact). It can also calculate a consensus genome, and other tasks. This program can also generate a consensus sequence for the mtDNA genome, but we will not examine this function in this tutorial.

In this exercise, we will focus on contamination estimates generated by comparing with a reference database of potential contaminant mtDNA genomes. Navigate to the folder **SchmutziReports**. There are two sets of files per each sample. The **final.cont.est** file lists the estimate of present-day human contamination with confidence intervals in the format: Sample estimate, Lower Bound, Upper Bound. The **final.cont.pdf** file plots the posterior probability of contamination per sample. Example for IndC:

![alt text](https://github.com/mnievesc/ENAH_curso_aDNA_2019/blob/master/Ex1_aDNA_BAM/images/484DD9D70AEFCB7AB797D984E27E1D6B.png)

**Compare the Schmutzi output and plots per each sample and answer the following questions:**
* Do any of the samples look like they are contaminated?
* If so, is this evidence consistent with what you observed with the summary statistics and damage patterns?

&nbsp;

---

### Bringing it all together
After completing all steps, answer the following questions:
* Which of the three samples we examined in this exercise looks more promising for downstream analyses? Why?
* Would you exclude any samples from further analyses? If so, why?
* Can you think of any other data or evidence you could use to make this assesment?

---

### References for further study:
1. Andrews, R. M., I. Kubacka, P. F. Chinnery, R. N. Lightowlers, D. M. Turnbull, and N. Howell.   1999. "Reanalysis and revision of the Cambridge reference sequence for human mitochondrial DNA." Nature Genetics 23 (2):147-147.
2. Jónsson, H., A. Gonolhac, M. Schubert, P. Johnson, and L. Orlando. 2013. "mapDamage2.0: fast approximate Bayesian estimates of ancient DNA damage parameters." Bioinformatics 29 (13):1682-1684.
3. Milne, I., G. Stephen, M. Bayer, P. J. A. Cock, L. Pritchard, L. Cardle, P. D. Shaw, and D. Marshall. 2013. "Using Tablet for visual exploration of second-generation sequencing data." Briefings in Bioinformatics 14 (2):193-202.
4. Okonechnikov, K., A. Conesa, and F. García-Alcalde. 2016. "Qualimap 2: advanced multi-sample quality control for high-throughput sequencing data." Bioinformatics 32 (2):292-294.
5. Peltzer, A., G. Jäger, A. Herbig, A. Seitz, C. Kniep, J. Krause, and K. Nieselt. 2016. "EAGER: efficient ancient genome reconstruction." Genome Biology 17 (1):60.
6. Renaud, G., Slon, V., Duggan, A.T. and Kelso J. 2015. "Schmutzi: estimation of contamination and endogenous mitochondrial consensus calling for ancient DNA". Genome Biology 16:224.
