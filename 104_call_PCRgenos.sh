#!/bin/bash
#SBATCH -o 19_call_PCRgenos-%j.out
#SBATCH --mem 32G

mkdir PCR_genos

#remove resident sample
ls $PWD/PCR_samples/*pcr_sorted.bam | grep -v 27_D01 > PCR_genos/PCR_geno.bamlist

angsd -bam PCR_genos/PCR_geno.bamlist -out PCR_genos/PCR_geno -GL 1 -doMajorMinor 1 -doMaf 2 -doGeno 4 -doPost 2 -postCutoff 0.8 -r scaffold79929e:600000-700000 

gunzip PCR_genos/*gz

perl scripts/call_cons.pl PCR_genos/PCR_geno.bamlist PCR_genos/PCR_geno.geno 1 > PCR_genos/PCR_geno_cons.fa
