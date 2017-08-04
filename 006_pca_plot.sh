#!/bin/bash -l
#SBATCH -o 06_pca_plot-%j.out
ls RAD_pca/*bamlist | sed 's:RAD_pca/::g' | sed 's:.bamlist::g' > list

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
	echo -e "$c1 \t $spp"

	#make annot file from bamlist (clst format)
	echo "FID_IID_CLUSTER_IDVAR" | awk -F_ '{print $1"\t"$2"\t"$3"\t"$4}'> RAD_pca/${c1}.clst
	cat RAD_pca/${c1}.bamlist | sed 's:.*samples/::g' | sed 's:ss....bam::g' | awk -F_ '{print $4"_"$5"\t1\t"$2"\t"$3}' >> RAD_pca/${c1}.clst

	#plot pdfs
        Rscript --vanilla --slave scripts/plot_pca.R -i RAD_pca/${c1}.covar -s ${spp} -c 1-2 -a RAD_pca/${c1}.clst -o plots/${c1}_12_pca.pdf
 
x=$(( $x + 1 ))
done
rm list

