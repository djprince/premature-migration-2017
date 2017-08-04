#!/bin/bash -l
#SBATCH -o 07b_fstpw-%j.out
ls RAD_fst/??.bamlist | sed 's:RAD_fst/::g' | sed 's:.bamlist::g' > fstlist
wc=$(wc -l fstlist | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do

        string="sed -n ${x}p fstlist" 
        str=$($string)

        var=$(echo $str | awk -F"\t" '{print $1}')   
        set -- $var
        spp=$1

       #get list of all possible pairwise pop comparisons
        perl scripts/list_to_pwcomps.pl RAD_fst/${spp}.poplist > RAD_fst/${spp}.pwlist

        #calc fst between each pw pair of pops
        wc2=$(wc -l RAD_fst/${spp}.pwlist | awk '{print $1}')
        x2=1
        while [ $x2 -le $wc2 ]  
        do

                string="sed -n ${x2}p RAD_fst/${spp}.pwlist"
                str2=$($string)

                var2=$(echo $str2 | awk -F"\t" '{print $1}')
                set -- $var2
                pop1=$1
                pop2=$2
echo "#!/bin/bash
/home/djprince/programs/angsd/misc/realSFS -tole 1e-12 RAD_fst/${spp}_${pop1}.saf.idx RAD_fst/${spp}_${pop2}.saf.idx > RAD_fst/${spp}_${pop1}_${pop2}.ml
/home/djprince/programs/angsd/misc/realSFS fst index RAD_fst/${spp}_${pop1}.saf.idx RAD_fst/${spp}_${pop2}.saf.idx -sfs RAD_fst/${spp}_${pop1}_${pop2}.ml -fstout RAD_fst/${spp}_${pop1}_${pop2}.fstout
/home/djprince/programs/angsd/misc/realSFS fst stats RAD_fst/${spp}_${pop1}_${pop2}.fstout.fst.idx > RAD_fst/${spp}_${pop1}_${pop2}.finalfstout" > ${pop1}_${pop2}_fst.sh
sbatch --mem 16G ${pop1}_${pop2}_fst.sh
rm ${pop1}_${pop2}_fst.sh
sleep 2m
                x2=$(( $x2 + 1 ))
        done
sleep 20m
 x=$(( $x + 1 ))
done
rm fstlist
