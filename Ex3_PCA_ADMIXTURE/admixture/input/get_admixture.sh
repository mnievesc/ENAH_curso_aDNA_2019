#!/bin/bash

## Script for using ADMIXTURE to determine ancestry from genomewide SNP data
## Written by M. Nieves Colon (mnievesc@asu.edu) - May 13, 2015 (based on ADMIXTURE manual)

## Input files should be in binary plink (bed/bim/fam) or .ped/.map plink and merged
## for X sample and reference panel
## Usage: ./get_ADMIXTURE.sh  $1=merged_dataset_basename


##   Unsupervised analysis.
##   Run ADMIXTURE for K 2-10 with the crossvalidation parameter activated such
## that we can see the CV errors. The ideal K is the one with the lowest cv errors.
## The tee command is for taking the standard output and writing it to a file.

# Necessary programs and modules
admixture=/data/programs/bin/admixture

## 1. LD trim merged dataset
plink --bfile ${1} --indep-pairwise 50 10 0.1 --out ${1}
plink --bfile ${1} --extract ${1}.prune.in --geno 0.1 --make-bed --out ${1}.LDpruned


# 2. Run ADMIXTURE in parallel for all .bed files and for K 2 to 20.
for K in {2..10}; do $admixture --cv -j2 ${1}.LDpruned.bed $K | tee  $1.log${K}.out; done


# 4. Use grep to see the cv parameter (-h is for supressing file name)
grep -h CV ${1}.log*.out
grep -h CV ${1}.log*.out > $1.Kcomparison.txt
