#!/bin/bash -l
#SBATCH -o 17_aln_PCRseqs-%j.out
mkdir PCR_alignments
#align PCR sequences and count
wc=$(wc -l metadata/PCRseqID_DNAposID.list | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do
	string="sed -n ${x}p metadata/PCRseqID_DNAposID.list" 
	str=$($string)

	var=$(echo $str | awk -F"\t" '{print $1,$2}')   
	set -- $var
	c1=$1
	c2=$2
	echo "#!/bin/bash -l" >> aln_${c1}.sh
	echo "#SBATCH -o PCR_alignments/${c1}-%j.out" >> aln_${c1}.sh
	echo "bwa bwasw genome/Oncorhynchus_mykiss_modified.fa PCR_sequence/${c1}_R1.fastq PCR_sequence/${c1}_R2.fastq > PCR_alignments/${c1}.sam"  >> aln_${c1}.sh
	echo "samtools view -bS PCR_alignments/${c1}.sam > PCR_alignments/${c1}.bam" >> aln_${c1}.sh
	echo "samtools sort PCR_alignments/${c1}.bam PCR_alignments/${c1}_sorted" >> aln_${c1}.sh
	echo "samtools index PCR_alignments/${c1}_sorted.bam" >> aln_${c1}.sh
	echo "samtools view -b -f 0x2 PCR_alignments/${c1}_sorted.bam scaffold79929e > PCR_alignments/${c1}_sorted_proper.bam" >> aln_${c1}.sh
	echo "sleep 2m" >> aln_${c1}.sh
	echo "samtools index PCR_alignments/${c1}_sorted_proper.bam" >> aln_${c1}.sh
	echo "reads=\$(samtools view -c PCR_alignments/${c1}_sorted.bam)" >> aln_${c1}.sh
        echo "ppalign=\$(samtools view -c PCR_alignments/${c1}_sorted_proper.bam)" >> aln_${c1}.sh
        echo "echo \"\${reads},\${ppalign}\" > PCR_alignments/${c1}.stats" >> aln_${c1}.sh


	sbatch -J pcraln aln_${c1}.sh
	rm aln_${c1}.sh

	x=$(( $x + 1 ))

done
