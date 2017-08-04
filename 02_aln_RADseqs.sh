#!/bin/bash -l

mkdir RAD_alignments/
wc=$(wc -l metadata/RADseqID_DNAID.list | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do
	string="sed -n ${x}p metadata/RADseqID_DNAID.list" 
	str=$($string)

	var=$(echo $str | awk -F"\t" '{print $1}')   
	set -- $var
	c1=$1
echo "#!/bin/bash
bwa aln genome/Oncorhynchus_mykiss_modified.fa RAD_sequence/${c1}_R1.fastq > RAD_alignments/${c1}_R1.sai
bwa aln genome/Oncorhynchus_mykiss_modified.fa RAD_sequence/${c1}_R2.fastq > RAD_alignments/${c1}_R2.sai
bwa sampe genome/Oncorhynchus_mykiss_modified.fa RAD_alignments/${c1}_R1.sai RAD_alignments/${c1}_R2.sai RAD_sequence/${c1}_R1.fastq RAD_sequence/${c1}_R2.fastq > RAD_alignments/${c1}.sam
samtools view -bS RAD_alignments/${c1}.sam > RAD_alignments/${c1}.bam
samtools sort  RAD_alignments/${c1}.bam RAD_alignments/${c1}_sorted
samtools view -b -f 0x2 RAD_alignments/${c1}_sorted.bam > RAD_alignments/${c1}_sorted_proper.bam
samtools rmdup RAD_alignments/${c1}_sorted_proper.bam RAD_alignments/${c1}_sorted_proper_rmdup.bam
samtools index RAD_alignments/${c1}_sorted_proper_rmdup.bam RAD_alignments/${c1}_sorted_proper_rmdup.bam.bai
reads=\$(samtools view -c RAD_alignments/${c1}_sorted.bam)
ppalign=\$(samtools view -c RAD_alignments/${c1}_sorted_proper.bam)
rmdup=\$(samtools view -c RAD_alignments/${c1}_sorted_proper_rmdup.bam)
echo \"\${reads},\${ppalign},\${rmdup}\" > RAD_alignments/${c1}.stats" > al1_${x}.sh
sbatch -p low -t 24:00:00 al1_${x}.sh
rm al1_${x}.sh
sleep 5m
	x=$(( $x + 1 ))
done

#for Chinook RAD reads only.... also align after trimming R1s to 75bp 
grep Ch_ metadata/DNAID_FileID.list | awk '{print $1}'> tmp; grep -f tmp metadata/RADseqID_DNAID.list | awk '{print $1}'> Ch_list; rm tmp
wc=$( wc -l Ch_list | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do
       string="sed -n ${x}p Ch_list" 
       str=$($string)

       var=$(echo $str | awk -F"\t" '{print $1}')   
       set -- $var
       c1=$1
echo "#!/bin/bash
perl scripts/trim_Ch_R1s.pl ${c1}
bwa aln genome/Oncorhynchus_mykiss_modified.fa RAD_sequence/${c1}_75_R1.fastq > RAD_alignments/${c1}_75_R1.sai
bwa aln genome/Oncorhynchus_mykiss_modified.fa RAD_sequence/${c1}_R2.fastq > RAD_alignments/${c1}_R2.sai
bwa sampe genome/Oncorhynchus_mykiss_modified.fa RAD_alignments/${c1}_75_R1.sai RAD_alignments/${c1}_R2.sai RAD_sequence/${c1}_75_R1.fastq RAD_sequence/${c1}_R2.fastq > RAD_alignments/${c1}_75.sam
samtools view -bS RAD_alignments/${c1}_75.sam > RAD_alignments/${c1}_75.bam
samtools sort  RAD_alignments/${c1}_75.bam RAD_alignments/${c1}_75_sorted
samtools view -b -f 0x2 RAD_alignments/${c1}_75_sorted.bam > RAD_alignments/${c1}_75_sorted_proper.bam
samtools rmdup RAD_alignments/${c1}_75_sorted_proper.bam RAD_alignments/${c1}_75_sorted_proper_rmdup.bam
sleep 2m
samtools index RAD_alignments/${c1}_75_sorted_proper_rmdup.bam RAD_alignments/${c1}_75_sorted_proper_rmdup.bam.bai
reads=\$(samtools view -c RAD_alignments/${c1}_75_sorted.bam)
ppalign=\$(samtools view -c RAD_alignments/${c1}_75_sorted_proper.bam)
rmdup=\$(samtools view -c RAD_alignments/${c1}_75_sorted_proper_rmdup.bam)
echo \"\${reads},\${ppalign},\${rmdup}\" > RAD_alignments/${c1}_75.stats" > alt_${x}.sh
sbatch -p low -t 24:00:00 alt_${x}.sh
rm alt_${x}.sh
sleep 5m
       x=$(( $x + 1 ))
done
rm Ch_list
