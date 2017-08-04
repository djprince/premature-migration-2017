#!/bin/bash -l
#SBATCH -o 08_fst_plot-%j.out

ls RAD_fst/*pwlist | sed 's:RAD_fst/::g' | sed 's:.pwlist::g' > list

wc=$(wc -l list | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do

        string="sed -n ${x}p list" 
        str=$($string)
        var=$(echo $str | awk -F"\t" '{print $1}')   
        set -- $var
        spp=$1
		
	rm RAD_fst/${spp}.pwfst

	wc1=$(wc -l RAD_fst/${spp}.pwlist | awk '{print $1}')
	x1=1
	while [ $x1 -le $wc1 ] 
	do

		string="sed -n ${x1}p RAD_fst/${spp}.pwlist"
		str1=$($string)

		var1=$(echo $str1 | awk -F"\t" '{print $1,$2}')
		set -- $var1
		pop1=$1
		pop2=$2

		fst=$(awk '{print $2}' RAD_fst/${spp}_${pop1}_${pop2}.finalfstout)


		echo -e "${pop1}\t${pop2}\t${fst}" >> RAD_fst/${spp}.pwfst
				
	x1=$(( $x1 + 1 ))
	done
	
	perl scripts/pwlist_to_matrix.pl RAD_fst/${spp}.pwfst > RAD_fst/${spp}.fstmatrix
	Rscript --vanilla --slave scripts/plot_fst.R ${spp}		
	
x=$(( $x + 1 ))
done
rm list
