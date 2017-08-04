#!/bin/bash -l
#SBATCH -t 2-00:00:00


	mkdir PCR_trees/


echo "#!/bin/bash -l"> PCR_geno_cons_tree.sh

#convert fasta to phylip input		
echo "job=\$SLURM_ARRAY_TASK_ID
cd PCR_phase/PCR_geno_cons_fastPHASE/\${job}/
nInd=\$(grep \">\" PCR_geno_cons_fPout_\${job}.fa_2 | wc -l | awk '{print \$1}')
nBases1=\$(head -n 2 PCR_geno_cons_fPout_\${job}.fa_2 | tail -n 1 | wc | awk '{print \$3}')
nBases=\$((\$nBases1-1))
echo -e \"\t\${nInd}\t\${nBases}\" > PCR_geno_cons_fPout_\${job}.phy
sed ':a;N;\$!ba;s/\\n/ /g' PCR_geno_cons_fPout_\${job}.fa_2 | sed -e 's/ >/\\n/g' | sed 's/_//g' | sed 's/ //g' | sed 's/>//g' | sed 's/^[CS]//' >> PCR_geno_cons_fPout_\${job}.phy" >> PCR_geno_cons_tree.sh

#set dummy outfiles to prompt call for input/output file names in phylip
echo "echo \"fill\" > outfile
echo \"fill\" > outtree
rm PCR_geno_cons_fPout_\${job}.phy.out*" >> PCR_geno_cons_tree.sh

#set phylip input parameters
echo "echo \"PCR_geno_cons_fPout_\${job}.phy
F
PCR_geno_cons_fPout_\${job}.phy.outfile
V
1
J
111
3
Y
F
PCR_geno_cons_fPout_\${job}.phy.outtree\" > param.in" >> PCR_geno_cons_tree.sh


echo "srun -t 2-00:00:00 --mem 8G phylip-3.695/exe/dnapars < param.in > PCR_geno_cons_fPout_\${job}.phystdout" >> PCR_geno_cons_tree.sh
        
		sbatch -p low -t 2-00:00:00 --array=1-1000  PCR_geno_cons_tree.sh
