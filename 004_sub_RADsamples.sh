#!/bin/bash -l
#SBATCH -o 04_sub_RADsamples-%j.out
wc=$(wc -l metadata/DNAID_FileID.list | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do
	string="sed -n ${x}p metadata/DNAID_FileID.list" 
	str=$($string)

	var=$(echo $str | awk -F"\t" '{print $1, $2}')   
	set -- $var
	c1=$1
	c2=$2

	count=$(samtools view -c RAD_samples/${c2}_75_R1.bam)

	if [ 60000 -le $count ]
        then
                frac=$(bc -l <<< 60000/$count)
                samtools view -bs $frac RAD_samples/${c2}_75_R1.bam > RAD_samples/${c2}_75_R1_ss60.bam
                samtools index RAD_samples/${c2}_75_R1_ss60.bam RAD_samples/${c2}_75_R1_ss60.bam.bai
        fi
	
	count=$(samtools view -c RAD_samples/${c2}.bam)

        if [ 120000 -le $count ]
        then
                frac=$(bc -l <<< 120000/$count)
                samtools view -bs $frac RAD_samples/${c2}.bam > RAD_samples/${c2}_ss120.bam
                samtools index RAD_samples/${c2}_ss120.bam RAD_samples/${c2}_ss120.bam.bai
        fi


	x=$(( $x + 1 ))

done

#to free up space can now:
#rm -r RAD_alignments/

#and since only chinook need to have trimmed R1 alignments
rm RAD_samples/St*75_R1*
