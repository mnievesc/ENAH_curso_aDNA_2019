# Curso de Paleogenómica y Antropología ENAH Mayo 2019

## __Exercise 2: Assigning and interpreting mtDNA haplogroups__

**Author:** Maria Nieves Colón (maria.nieves@cinvestav.mx / mnievesc@asu.edu)

---
### Learning Objectives:
In this tutorial we will use the online server HaploGrep to determine which mtDNA haplogroups are present in our ancient samples. We will use open-access online resources such as Phylotree and EMPOP to interpret these assignments. At the end of this exercise students should:
* Know the overall topology of the human mtDNA tree and the terminology and notation used for describing human mtDNA variation.
* Understand the basic workflow for determining human mtDNA lineages from NGS data.
* Be familiar with available online resources for researching human mtDNA haplogroup diversity and finding comparative datasets.
* Understand how ancient mtDNA results are interpreted and contextualized with other lines of evidence.


&nbsp;

### Necessary online resources
* HaploGrep 2 (http://HaploGrep.uibk.ac.at/). Note that you can also download HaploGrep as a standalone application to your local compute. Download link: https://github.com/seppinho/haplogrep-cmd
* Phylotree (http://www.phylotree.org/)
* EMPOP (https://empop.online/) Note that EMPOP is free to use but requires pre-registration.

&nbsp;
### Input files:
#### 1. VCF files containing complete mtDNA genotypes for three ancient samples.
```
IndA.covfilt.vcf
IndB.covfilt.vcf
IndC.covfilt.vcf
```
The variant call format (VCF) is a text file that contains information on DNA polymorphisms present in our sample. It is obtained after variant calling on NGS data. The VCF file also contains information such as read depth and mapping quality per each genomic position. This is useful because it allows us to filter our dataset. In this case, we generated VCF files after calling variants with `SAMtools mpileup`. We also implemented a coverage filter so that only those positions with read depth >1x were considered in our analysis. To generate the VCF files we will use in this exercise we used the following command:
```
 samtools mpileup -f $ref -C 50 -Bu IndA.bam | bcftools view -vcg -s IndA.sample.txt - | grep -v "DP=1;" > IndA.covfilt.vcf
```
For more in-depth discussion on the VCF format and how to filter variant calls access this tutorial: https://github.com/mnievesc/AAAGs_2018/tree/master/Session3_VCFFormat

&nbsp;

**Questions to consider:**
* Why do you think we filtered our dataset with a 1x read depth threshold filter?
* What other quality metrics may be useful for filtering ancient DNA datasets?
* Optional: Search for the manuals for SAMtools and bcftools online. What is the command above doing?

&nbsp;

---

### 2.1 Assigning mtDNA haplogroups with HaploGrep
HaploGrep is an algorithm which automatizes the process of human mtDNA haplogroup classification. The program works by considering the mtDNA variants present in a given sample in relation to the rCRS complete mtDNA genome reference. HaploGrep scans the latest version of the human mtDNA phylogenetic tree listed in Phylotree (currently build 17) and estimates the most likely haplogroup assignment for the sample given the provided variants.

To access HaploGrep open your online browser and navigate to this website: http://HaploGrep.uibk.ac.at/. You may also want to open the HaploGrep manual page in another tab on your browser (http://HaploGrep.uibk.ac.at/docs/UserManual-HaploGrep.pdf) and the HaploGrep blog (http://HaploGrep.uibk.ac.at/blog/), both are excellent resources for understanding how to use this tool.

On the HaploGrep home page, click on the prompt that says **Run HaploGrep**. Next, click on the **Open** button on the top left of the screen and choose file `IndA.covfilt.vcf` as input.

![alt text](https://github.com/mnievesc/ENAH_curso_aDNA_2019/blob/master/Ex2_MThaplogroups/images/Screen%20Shot%202019-04-11%20at%2012.08.16%20PM.png)

&nbsp;

After the file loads, in the top window you will see a list of all the polymorphisms present in the sample. This list is taken directly from the input file, in our case the coverage filtered VCF. In addition to VCF, HaploGrep also accepts other formats including HSD and FASTA files. See the manual and blog for specifications.

![alt text](https://github.com/mnievesc/ENAH_curso_aDNA_2019/blob/master/Ex2_MThaplogroups/images/Screen%20Shot%202019-04-11%20at%2012.14.44%20PM.png)

&nbsp;

You will also see that HaploGrep presents the most probably haplogroup assignment and the quality of the estimation. Confidence in this estimation is shown with color as listed in the HaploGrep manual.

![alt text](https://github.com/mnievesc/ENAH_curso_aDNA_2019/blob/master/Ex2_MThaplogroups/images/Screen%20Shot%202019-04-11%20at%2012.32.03%20PM.png)

&nbsp;

Other potential haplogroup assignments ranked by score are shown in the second window to the left, along with their overall quality. This blog post explains how the quality scores are calculated: http://haplogrep.uibk.ac.at/blog/explaining-the-formula/. The windows on the bottom left of the screen list the **Expected** diagnostic polymorphisms required for assignment to each haplogroup, and wether or not these are present in our sample (**Found**). Other remaining polymorphisms are listed in the next window. These are classified in three categories as listed in the manual:

![alt text](https://github.com/mnievesc/ENAH_curso_aDNA_2019/blob/master/Ex2_MThaplogroups/images/Screen%20Shot%202019-04-11%20at%2012.40.47%20PM.png)

&nbsp;

Lastly, the center window displays a graph showing the lineage path from the rCRS reference to the currently selected haplogroup.  The polymorphisms are color-coded as follows:

![alt text](https://github.com/mnievesc/ENAH_curso_aDNA_2019/blob/master/Ex2_MThaplogroups/images/Screen%20Shot%202019-04-11%20at%2012.48.00%20PM.png)

&nbsp;

**Examine the HaploGrep results and answer the following questions:**
Remember, although the algorithm provides an initial assessment, **you**, the end user must also critically evaluate these assignments.
* How confident is the HaploGrep assignment? Why do you think the quality does not reach 100%?
* Try selecting several different haplogroup assignments with varying quality levels. How does the the center lineage graph change? Do the number of **Expected** versus **Found** polymorphisms listed in then bottom left window change? Which haplogroup seems like the most parsimonious assignment given the variants found in your sample?
* Why do you think it may be useful to look at the **Remaining** polymorphism window?

&nbsp;

HaploGrep can export the analysis results in several formats. To see them, click on the **Export** button in the top part of the screen. Today, we will export the results as _Haplogroups(hsd)_. The HSD lists the results as follows: the first column contains the sample ID, the second column specifies the targeted genetic region, the third column lists the assigned haplogroup status and then the polymorphisms are indicated separated by tab stops.

![alt text](https://github.com/mnievesc/ENAH_curso_aDNA_2019/blob/master/Ex2_MThaplogroups/images/Screen%20Shot%202019-04-12%20at%203.19.46%20PM.png)

&nbsp;

**Now, repeat these steps using the coverage filtered VCF for IndB and IndC as input and answer the following questions:**
* Which haplogroups are the most probable assignments for IndB and IndC?
* Is there any result that seems unexpected? Why do you think this is the case?


&nbsp;

---

### 2.2 Exploring the human mtDNA tree
Once we have determined which mtDNA haplogroups are present in our samples, our next step is to make sense of these results. To start, we may want to understand where these lineages fit within the human mtDNA tree and where they are found today.

To start, let's refresh our memory of the present-day worldwide distribution of mtDNA haplogroups:

![alt text](https://github.com/mnievesc/ENAH_curso_aDNA_2019/blob/master/Ex2_MThaplogroups/images/MTtree.gif)

&nbsp;

Notice that this map only lists haplogroups, but our HaploGrep assignments are more specific, down to the sub-haplogroup level. This is because each lineage has additional mutations which further define their place within the broader haplogroup clade. To learn more about each sub-haplogroup and we can use Phylotree. Phylotree is the most comprehensive phylogenetic tree of worldwide human mitochondrial DNA variation. It lists over 5,400 haplogroups with their defining mutations, and is constantly being updated as more sequences are published. To access Phylotree navigate to their homepage: http://www.phylotree.org/ and click on the link for the most recent tree **mtDNA tree Build 17**. This will take us the an interactive human mtDNA tree. Next, let's click on the subtree that contains the haplogroup assigned to IndA.


![alt text](https://github.com/mnievesc/ENAH_curso_aDNA_2019/blob/master/Ex2_MThaplogroups/images/Screen%20Shot%202019-04-12%20at%203.40.16%20PM.png)

&nbsp;

**Explore Phylotree and answer the following questions:**
* Navigate the subtree branches by tracing the diagnostic mutations until you find the specific lineage to which IndA belongs too. Make sure to read the text at the top of the page to understand how polymorphisms are represented on the tree. Use the HaploGrep output to guide you. _Hint_: To make your search easier try using CTRL+F and searching for diagnostic mutations specific to the assigned haplogroup as noted in the HaploGrep lineage graph.
* Next, repeat your search with the lineage assigned to individual IndC.
* Why are some mutations listed within parentheses: `(C64T)` ? Why do some mutations have exclamation marks:` T146C!`? How do you think  this information is helpful?
* Can you identify any mutations in our sample lineages that are not listed in Phylotree? Why is this important?

*_Note_*: The accession numbers provided at the tips of branches are representative examples of mtDNA sequences matching this lineage and available at GenBank.

&nbsp;

Now that we are well acquainted with the mtDNA lineages present in our samples and we understand their relationship to the broader human mtDNA tree, we may also want to know where they are found today and in what populations. Although there are many ways to do this, I like to start by looking at the frequency of these lineages in the EMPOP database. This database was originally established for forensics research. It contains polymorphism data for over 42,000 mtDNA genomes from around the world.

Navigate to the EMPOP website: https://empop.online. Login using your credentials. Once logged in click on the **Tools** button and navigate to the **Haplogroup Browser**.

![alt text](https://github.com/mnievesc/ENAH_curso_aDNA_2019/blob/master/Ex2_MThaplogroups/images/Screen%20Shot%202019-04-12%20at%204.26.27%20PM.png)


&nbsp;

Search for the haplogroup assigned to IndA by navigating the human mtDNA tree in the browser. Alternatively you can enter the haplogroup name in the **Jump to haplogroup** box to search directly.

![alt text](https://github.com/mnievesc/ENAH_curso_aDNA_2019/blob/master/Ex2_MThaplogroups/images/Screen%20Shot%202019-04-12%20at%204.42.56%20PM.png)


&nbsp;


**Explore the search results and answer the following questions:**
* What is the geographic distribution of this lineage in the EMPOP database? Where is it found most frequently?
* Repeat this same procedure with the lineage identified for IndC. Where is it found most frequently?
* What are the potential limitations of using a forensic database to make inferences about worldwide mtDNA lineage distribution? What biases may be present in our search?
* Assume that these samples comes from the Americas. Do these haplogroup assignments make sense given what you know about your study population?  If not, what does that suggest?
* Based on your findings and the results you obtained with Exercise 1, would you exclude any of these samples from further analyses? If so, why?

*_Note_*: If you only have mtDNA polymorphism data you can also use EMPOP to assign haplogroups using the **Query** tool: https://empop.online/haplotypes#query_form

---

### Bringing it all together: How do you interpret these data?
In the time we have left, research the evolutionary history of IndA's mtDNA lineage. Try to answer the following questions:
* Where did this lineage evolve?
* How old is it?
* What modern populations carry this lineage? What is it's frequency in the Americas today?
* Is the present-day distribution of this lineage the same as in the past, or has it changed?
* What comparative analyses could you carry out to understand more about your study population?
* What are the potential limitations of basing all your analyses on mtDNA data? What other lines of evidence (genomic or otherwise) do you need to interpret this finding within an anthroplogical framework?

&nbsp;

**Additional useful tools for exploring human mtDNA variation:**
* *Haplofind*, for assigning mtDNA haplogroups using FASTA files as input: https://haplofind.unibo.it/
* *Mitomap*, an overview of diagnostic haplogroup mutations: https://www.mitomap.org/foswiki/bin/view/MITOMAP/HaplogroupMarkers
* *Mitomap* GB database, a searchable database of mtDNA genomes submitted to Genbank (organized by haplogroup): https://www.mitomap.org/foswiki/bin/view/MITOMAP/GBFreqInfo
* *Mitotool*, for assigning mtDNA haplogroups using FASTA and polymorphism data, also has a searchable Genbank database: http://www.mitotool.org/index.html
* *AmtDB*, ancient mtDNA gneome database (mostly from Europe): https://amtdb.org/


---

### References for further study:
1. van Oven, M., and M. Kayser. 2009. "Updated comprehensive phylogenetic tree of global human mitochondrial DNA variation." Human Mutation 30 (2):E386-E394.
2. Weissensteiner, H., D. Pacher, A. Kloss-Brandstätter, L. Forer, G. Specht, H.-J. Bandelt, F. Kronenberg, A. Salas, and S. Schönherr. 2016. "HaploGrep 2: mitochondrial haplogroup classification in the era of high-throughput sequencing." Nucleic Acids Research 44 (W1):W58-W63.
3. Behar, D.M, van Oven, M., Rosset, S., Metspalu, M., Loogväli, E., Silva, N.M., Kivisild, T., Torroni, A. and R. Villems. 2012. "A “Copernican” Reassessment of the Human Mitochondrial DNA Tree from its Root" American Journal of Human Genetics. 90(4): 675–684.
4. Achilli, A., U. A. Perego, C. M. Bravi, M. D. Coble, Q. P. Kong, S. R. Woodward, A. Salas, A. Torroni, and H. J. Bandelt. 2008. "The phylogeny of the four pan-American MtDNA haplogroups: implications for evolutionary and disease studies." PLoS One 3 (3):e1764.
5. Tamm, E., T. Kivisild, M. Reidla, M. Metspalu, D. G. Smith, C. J. Mulligan, C. M. Bravi, O. Rickards, C. Martinez-Labarga, E. K. Khusnutdinova, S. A. Fedorova, M. V. Golubenko, V. A. Stepanov, M. A. Gubina, S. I. Zhadanov, L. P. Ossipova, L. Damba, M. I. Voevoda, J. E. Dipierri, R. Villems, and R. S. Malhi. 2007. "Beringian Standstill and Spread of Native American Founders." PLoS One 2 (9):e829.
