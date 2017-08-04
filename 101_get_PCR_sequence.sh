#!/bin/bash -l

module load sratoolkit/2.8.2
mkdir PCR_sequence/

grep PCR metadata/SRR_seqID.list > metadata/PCR_seq.list

list="metadata/PCR_seq.list"

wc=$(wc -l $list | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do

	string="sed -n ${x}p $list" 
	str=$($string)

	var=$(echo $str | awk -F"\t" '{print $1,$2,$3}')   
	set -- $var
	c1=$1
	c2=$2
	c3=$3

	fastq-dump --defline-seq '@$si' --defline-qual '+$si' ${c1}
	mv ${c1}.fastq ${c2}/${c3}

x=$(( $x + 1 ))
done
