#!/bin/bash -l
#SBATCH -o 05_pca_calc-%j.out
#mkdir RAD_pca

ls $PWD/RAD_samples/St*ss120*bam > RAD_pca/St_120.bamlist
ls $PWD/RAD_samples/Ch*_75_R1*ss60*bam > RAD_pca/Ch_75_R1_60.bamlist

ls RAD_pca/*bamlist | sed 's:RAD_pca/::g' | sed 's:.bamlist::g' > pcalist


## to view intermediate position of potential resident fish:
#ls $PWD/RAD_samples/St_Eel*ss120*bam > RAD_pca/St_Eel_120.bamlist
#echo "St_Eel_120" > pcalist


wc=$(wc -l pcalist | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do

        string="sed -n ${x}p pcalist" 
        str=$($string)

        var=$(echo $str | awk -F"\t" '{print $1}')   
        set -- $var
        c1=$1

	nInd=$(wc -l RAD_pca/${c1}.bamlist | awk '{print $1}')
	minInd=$[$nInd/2]

	echo "#!/bin/bash -l" > ${c1}.sh
	echo "#SBATCH -o RAD_pca/${c1}-%j.out" >> ${c1}.sh
	echo "angsd -bam RAD_pca/${c1}.bamlist -out RAD_pca/${c1} -minQ 20 -minMapQ 10 -minInd $minInd -GL 1 -doMajorMinor 1 -doMaf 2 -SNP_pval 1e-6 -minMaf 0.05 -doGeno 32 -doPost 2" >> ${c1}.sh
	echo "gunzip RAD_pca/${c1}*.gz" >> ${c1}.sh
	echo "count=\$(sed 1d RAD_pca/${c1}*mafs| wc -l | awk '{print \$1}')" >> ${c1}.sh
	echo "/home/djprince/programs/ngsTools/ngsPopGen/ngsCovar -probfile RAD_pca/${c1}.geno -outfile RAD_pca/${c1}.covar -nind $nInd -nsites \$count -call 1" >> ${c1}.sh
	sbatch -p bigmemh -J djppca ${c1}.sh
	rm ${c1}.sh

 x=$(( $x + 1 ))
done
rm pcalist

