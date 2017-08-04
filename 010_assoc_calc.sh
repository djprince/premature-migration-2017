#!/bin/bash -l
#SBATCH -o 09_assoc_calc-%j.out
mkdir St_association
#all steelhead samples from 2 locations that have at least 120k reads
ls $PWD/RAD_samples/St_Eel*ss120*bam | sed 's/_ss120//g' > St_association/St_Eel.bamlist
ls $PWD/RAD_samples/St_Ump*ss120*bam | sed 's/_ss120//g' > St_association/St_Ump.bamlist

#all chinook samples with 120kreads as long as no more than 10 from each loc/rt pair are represented
ls $PWD/RAD_samples/Ch*ss120*bam | sed 's/_ss120//g' | awk -F_ ' {pop=$(NF-3) "_" $(NF-2); v[pop]++; if (v[pop] <= 10) {print $0} }' > St_association/Ch_All.bamlist 


ls St_association/*bamlist | sed 's/.bamlist//g' | sed 's:St_association/::g' > assoclist
wc=$(wc -l assoclist | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do

        string="sed -n ${x}p assoclist" 
        str=$($string)

        var=$(echo $str | awk -F"\t" '{print $1}')   
        set -- $var
        c1=$1

	nInd=$(wc -l St_association/${c1}.bamlist | awk '{print $1}')
        minInd=$[$nInd/2]

        sed -r 's/^.*_M_.*/0/g' St_association/${c1}.bamlist | sed -r 's/^.*_P_.*/1/g' > St_association/${c1}.ybin
        
        echo "#!/bin/bash -l" > assoc_${c1}.sh
        echo "#SBATCH -o St_association/${c1}-%j.out" >> assoc_${c1}.sh
        echo "" >> assoc_${c1}.sh
        echo "angsd -bam St_association/${c1}.bamlist -out St_association/${c1} -minQ 20 -minMapQ 10 -minInd $minInd -GL 1 -doMajorMinor 1 -doMaf 2 -SNP_pval 1e-6 -minMaf 0.05 -doAsso 1 -yBin St_association/${c1}.ybin" >> assoc_${c1}.sh
        
        sbatch --mem 16G -J djpass assoc_${c1}.sh
        rm assoc_${c1}.sh



        x=$(( $x + 1 ))

done
rm assoclist


mkdir Ch_association/

scripts/pull_covars.R RAD_pca/Ch_75_R1_60.covar 15 > Ch_association/Ch_All.cov15

ls $PWD/RAD_samples/Ch*ss120*bam | sed 's/_ss120//g'  > Ch_All.bamlist
ls *bamlist | sed 's/.bamlist//' > list


input="list"
wc=$(wc -l $input | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do

        string="sed -n ${x}p $input"
        str=$($string)

        var=$(echo $str | awk -F"\t" '{print $1}')
        set -- $var
pop=$1
nInd=$(wc -l ${pop}.bamlist | awk '{print $1}')
minInd=$[$nInd/2]

sed -r 's/^.*_M_.*/0/g' ${pop}.bamlist | sed -r 's/^.*_P_.*/1/g' > Ch_association/${pop}.yQuant

echo "#!/bin/bash -l" > assoc_${pop}_score_cov15.sh
echo "#SBATCH -o Ch_association/assoc_${pop}_score_cov15-%j.out" >> assoc_${pop}_score_cov15.sh
echo "#SBATCH --mem 60G" >> assoc_${pop}_score_cov15.sh
echo "" >> assoc_${pop}_score_cov15.sh
echo "angsd -bam ${pop}.bamlist -out Ch_association/assoc_${pop}_score_cov15 -minQ 20 -minMapQ 10 -cov Ch_association/${pop}.cov15 -minInd $minInd -GL 1 -doMajorMinor 1 -minHigh 1 -minCount 1 -doMaf 2 -SNP_pval 1e-6 -minMaf 0.05 -doAsso 2 -doPost 2 -yQuant Ch_association/${pop}.yQuant" >> assoc_${pop}_score_cov15.sh
sbatch -J djpass assoc_${pop}_score_cov15.sh



        x=$(( $x + 1 ))

done

