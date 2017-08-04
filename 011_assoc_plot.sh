#!/bin/bash -l
#SBATCH -o 10_assoc_plot-%j.out
mkdir RAD_association/
cp *association/*lrt0.gz RAD_association/
cp *association/*bamlist RAD_association/
ls RAD_association/*bamlist | sed 's:RAD_association/::g' | sed 's:.bamlist::g' > list
gunzip RAD_association/*gz

wc=$(wc -l list | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do

        string="sed -n ${x}p list" 
        str=$($string)

        var=$(echo $str | awk -F"\t" '{print $1}')   
        set -- $var
        c1=$1
	spp=${c1:0:2}
	
Rscript --vanilla --slave scripts/plot_assoc.R -i RAD_association/${c1}.lrt0 -s ${spp} -o ${c1}_assoc.pdf
 


x=$(( $x + 1 ))
done
rm list
