#!/bin/bash -l
#SBATCH -o 14_mafs_calc-%j.out
mkdir RAD_maf

ls $PWD/RAD_samples/Ch_???_?_??_???.bam > RAD_maf/Ch.bamlist
cat RAD_maf/Ch.bamlist | awk -F "RAD_samples/" '{print $2}' | awk -F_ '{print $2"_"$3}' | sort | uniq  > RAD_maf/Ch.poplist



wc=$(wc -l RAD_maf/Ch.poplist | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do

        string="sed -n ${x}p RAD_maf/Ch.poplist" 
        str=$($string)

        var=$(echo $str | awk -F"\t" '{print $1}')   
        set -- $var
        pop=$1

	grep ${pop} RAD_maf/Ch.bamlist > RAD_maf/Ch_${pop}.bamlist

	nInd=$(wc -l RAD_maf/Ch_${pop}.bamlist | awk '{print $1}')
        minInd=$[$nInd/2]

	angsd -bam RAD_maf/Ch_${pop}.bamlist -out RAD_maf/Ch_${pop} -ref genome/Oncorhynchus_mykiss_modified.fa -minQ 20 -minMapQ 10 -GL 1 -doMajorMinor 4 -doMaf 1 -r scaffold79929e:

 x=$(( $x + 1 ))
done
