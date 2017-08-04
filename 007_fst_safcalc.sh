#!/bin/bash -l
#SBATCH -o 07_fst_calc_5-%j.out

mkdir RAD_fst_5

ls $PWD/RAD_samples/St*ss120*bam | sed 's/_ss120//g' > RAD_fst_5/St.bamlist
ls $PWD/RAD_samples/Ch*_75_R1*ss60*bam |sed 's/_ss60//g' > RAD_fst_5/Ch.bamlist

ls RAD_fst_5/*bamlist | sed 's:RAD_fst_5/::g' | sed 's:.bamlist::g' > fstlist
wc=$(wc -l fstlist | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do

        string="sed -n ${x}p fstlist" 
        str=$($string)

        var=$(echo $str | awk -F"\t" '{print $1}')   
        set -- $var
        spp=$1


	#get list of uniq pops
	cat RAD_fst_5/${spp}.bamlist | awk -F "RAD_samples/" '{print $2}' | awk -F_ '{print $2"_"$3}' | sort | uniq > RAD_fst_5/${spp}.poplist

	#get saf file for each uniq pop

	wc1=$(wc -l RAD_fst_5/${spp}.poplist | awk '{print $1}')
	x1=1
	while [ $x1 -le $wc1 ] 
	do

		string="sed -n ${x1}p RAD_fst_5/${spp}.poplist"
		str1=$($string)

		var1=$(echo $str1 | awk -F"\t" '{print $1}')
		set -- $var1
		pop=$1
		
		grep ${pop} RAD_fst_5/${spp}.bamlist > RAD_fst_5/${spp}_${pop}.bamlist
		nind=$(wc -l RAD_fst_5/${spp}_${pop}.bamlist | awk '{print $1}')
		minpct="0.5"
		minind=$(echo "((${nind}*${minpct})+0.5)/1" | bc)

		angsd -bam RAD_fst_5/${spp}_${pop}.bamlist -out RAD_fst_5/${spp}_${pop} -anc genome/Oncorhynchus_mykiss_modified.fa -GL 1 -doSaf 1 -minQ 20 -minMapQ 10 -minInd $minind 

		x1=$(( $x1 + 1 ))
	done	

 x=$(( $x + 1 ))
done
rm fstlist
