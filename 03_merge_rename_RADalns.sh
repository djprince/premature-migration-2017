#!/bin/bash -l
#SBATCH -o 03_merge_rename_RADalns-%j.out
#scripts/slurm-catch.sh radaln

perl scripts/merge_bams.pl

scripts/slurm-catch.sh radmer

perl scripts/pull_R1s_merge.pl

scripts/slurm-catch.sh radmer

wc=$(wc -l metadata/DNAID_FileID.list | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do
	string="sed -n ${x}p DNAID_FileID.list" 
	str=$($string)

	var=$(echo $str | awk -F"\t" '{print $1, $2}')   
	set -- $var
	c1=$1
	c2=$2
	
	rename -f "s/${c1}/${c2}/g" RAD_samples/${c1}*

	x=$(( $x + 1 ))

done

