#!/bin/bash -l
#SBATCH -o 11_theta_calc_r1-%j.out
#SBATCH --mem 16G 

mkdir RAD_thetas_r1
#steelhead samples from Eel and Ump that have at least 120k reads (seperate RTs)
ls $PWD/RAD_samples/St_Eel*ss120*bam | sed 's/_ss120//g' | grep "_P_" > RAD_thetas_r1/St_Eel_P.bamlist
ls $PWD/RAD_samples/St_Eel*ss120*bam | sed 's/_ss120//g' | grep "_M_" > RAD_thetas_r1/St_Eel_M.bamlist
ls $PWD/RAD_samples/St_Ump*ss120*bam | sed 's/_ss120//g' | grep "_P_" > RAD_thetas_r1/St_Ump_P.bamlist
ls $PWD/RAD_samples/St_Ump*ss120*bam | sed 's/_ss120//g' | grep "_M_" > RAD_thetas_r1/St_Ump_M.bamlist

ls RAD_thetas_r1/*bamlist | sed 's/.bamlist//g' | sed 's:RAD_thetas_r1/::g' > thetalist_r1
wc=$(wc -l thetalist_r1 | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do

        string="sed -n ${x}p thetalist_r1" 
        str=$($string)

        var=$(echo $str | awk -F"\t" '{print $1}')   
        set -- $var
        c1=$1

	region="565000-785000"
	nInd=$(wc -l RAD_thetas_r1/${c1}.bamlist | awk '{print $1}')
	nChr=$(echo $[2* ${nInd}])
	minInd=$(echo $[$nInd/2])
 
        angsd -bam RAD_thetas_r1/${c1}.bamlist -out RAD_thetas_r1/${c1}_reg -anc genome/Oncorhynchus_mykiss_modified.fa -minInd $minInd -minQ 20 -minMapQ 10 -GL 1 -doSaf 1 -r scaffold79929e:$region
        /home/djprince/programs/angsd/misc/realSFS -tole 1e-12 RAD_thetas_r1/${c1}_reg.saf.idx > RAD_thetas_r1/${c1}_reg.sfs
	angsd -bam RAD_thetas_r1/${c1}.bamlist -out RAD_thetas_r1/${c1}_reg -anc genome/Oncorhynchus_mykiss_modified.fa -minInd $minInd -minQ 20 -minMapQ 10 -GL 1 -doSaf 1 -doThetas 1 -pest RAD_thetas_r1/${c1}_reg.sfs -r scaffold79929e:$region
	/home/djprince/programs/angsd/misc/thetaStat make_bed RAD_thetas_r1/${c1}_reg.thetas.gz
	/home/djprince/programs/angsd/misc/thetaStat do_stat RAD_thetas_r1/${c1}_reg.thetas.gz -nChr $nChr 

        angsd -bam RAD_thetas_r1/${c1}.bamlist -out RAD_thetas_r1/${c1}_gw -anc genome/Oncorhynchus_mykiss_modified.fa -minInd $minInd -minQ 20 -minMapQ 10 -GL 1 -doSaf 1
        /home/djprince/programs/angsd/misc/realSFS -tole 1e-12 RAD_thetas_r1/${c1}_gw.saf.idx > RAD_thetas_r1/${c1}_gw.sfs
        angsd -bam RAD_thetas_r1/${c1}.bamlist -out RAD_thetas_r1/${c1}_gw -anc genome/Oncorhynchus_mykiss_modified.fa  -minInd $minInd -minQ 20 -minMapQ 10 -GL 1 -doSaf 1 -doThetas 1 -pest RAD_thetas_r1/${c1}_gw.sfs
        /home/djprince/programs/angsd/misc/thetaStat make_bed RAD_thetas_r1/${c1}_gw.thetas.gz
        /home/djprince/programs/angsd/misc/thetaStat do_stat RAD_thetas_r1/${c1}_gw.thetas.gz -nChr $nChr 
        x=$(( $x + 1 ))

done
rm thetalist_r1
