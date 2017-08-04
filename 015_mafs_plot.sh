#!/bin/bash -l
#SBATCH -o 15_mafs_plot-%j.out
gunzip RAD_maf/*gz
rm -f RAD_maf/??????.txt
wc=$(wc -l RAD_maf/Ch.poplist | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do

        string="sed -n ${x}p RAD_maf/Ch.poplist" 
        str=$($string)

        var=$(echo $str | awk -F"\t" '{print $1}')   
        set -- $var
        pop=$1

	line=$(grep 569200 RAD_maf/Ch_${pop}.mafs | awk '{print $2"\t"$3"\t"$4"\t"$6}')
	echo -e "${pop}\t${line}" >> RAD_maf/569200.txt
	line=$(grep 595121 RAD_maf/Ch_${pop}.mafs | awk '{print $2"\t"$3"\t"$4"\t"$6}')
	echo -e "${pop}\t${line}" >> RAD_maf/595121.txt
	line=$(grep 537741 RAD_maf/Ch_${pop}.mafs | awk '{print $2"\t"$4"\t"$3"\t"(1-$6)}')
	echo -e "${pop}\t${line}" >> RAD_maf/537741.txt
	line=$(grep 592438 RAD_maf/Ch_${pop}.mafs | awk '{print $2"\t"$4"\t"$3"\t"(1-$6)}')
	echo -e "${pop}\t${line}" >> RAD_maf/592438.txt
	line=$(grep 569271 RAD_maf/Ch_${pop}.mafs | awk '{print $2"\t"$3"\t"$4"\t"$6}')
	echo -e "${pop}\t${line}" >> RAD_maf/569271.txt

x=$(( $x + 1 ))
done

cat RAD_maf/??????.txt > RAD_maf/allelefreqs.txt
awk '{print $1,$2,$5}' RAD_maf/allelefreqs.txt | sed 's/Eel_M/1/g' | sed 's/Tri_M/2/g' | sed 's/Sal_M/3/g' | sed 's/Rog_M/4/g' | sed 's/Sou_M/5/g' | sed 's/Sil_M/6/g' | sed 's/Puy_M/7/g' | sed 's/Noo_M/8/g' | sed 's/Tri_P/9/g' | sed 's/Sal_P/10/g' | sed 's/Rog_P/11/g' | sed 's/Nor_P/12/g' | sed 's/Sil_P/13/g' | sed 's/Puy_P/14/g' | sed 's/Noo_P/15/g' | sed 's/537741/1/g' | sed 's/569200/2/g' | sed 's/569271/3/g' | sed 's/592438/4/g' | sed 's/595121/5/g' > RAD_maf/maf_R.input

Rscript --slave --vanilla scripts/plot_maf.R maf_R.input


