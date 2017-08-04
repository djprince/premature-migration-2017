#!/bin/bash -l
#SBATCH -o 18_merge_PCRalns-%j.out
mkdir PCR_samples
wc=$(wc -l metadata/PCRseqID_DNAposID.list | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do
	string="sed -n ${x}p metadata/PCRseqID_DNAposID.list" 
	str=$($string)

	var=$(echo $str | awk -F"\t" '{print $1, $2}')   
	set -- $var
	c1=$1
	c2=$2

	count=$(samtools view -c PCR_alignments/${c1}_sorted_proper.bam)

	if [ 20 -le $count ]
        then
                cp PCR_alignments/${c1}_sorted_proper.bam PCR_samples/${c2}_sorted_proper.bam
        fi
	
	x=$(( $x + 1 ))

done

wc=$(wc -l DNAID_FileID.list | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do

string="sed -n ${x}p DNAID_FileID.list"
        str=$($string)

        var=$(echo $str | awk -F"\t" '{print $1, $2}')
        set -- $var
        c1=$1
        c2=$2

	if [ 2 -le $(ls PCR_samples/${c1}*sorted_proper.bam | wc -l | awk '{print $1}') ]
	then
		samtools merge PCR_samples/${c2}_pcr.bam PCR_samples/${c1}*sorted_proper.bam
		samtools sort PCR_samples/${c2}_pcr.bam PCR_samples/${c2}_pcr_sorted
		samtools index PCR_samples/${c2}_pcr_sorted.bam
		rm PCR_samples/${c1}*sorted_proper.bam
	fi
 x=$(( $x + 1 ))

done
rm PCR_samples/DNAA*
