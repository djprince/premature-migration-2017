#!/bin/bash -l
#SBATCH -t 2-00:00:00

mkdir PCR_tree

echo "#!/bin/bash -l

cat PCR_phase/PCR_geno_cons_fastPHASE/*/PCR_geno_cons*outtree > PCR_tree/PCR_geno_cons_1kcat.outtree
cd PCR_tree/" > PCR_geno_cons_tree.sh

#set dummy outfiles to prompt call for input/output file names in phylip
echo "echo \"fill\" > outfile
echo \"fill\" > outtree
rm PCR_geno_constree.out*" >> PCR_geno_cons_tree.sh

#set phylip input parameters
echo "echo \"PCR_geno_cons_1kcat.outtree
F
PCR_geno_constree.outfile
y
F
PCR_geno_constree.outtree\" > PCR_geno_consparam.in" >> PCR_geno_cons_tree.sh


echo "srun -p high -t 2-00:00:00 --mem 8G phylip-3.695/exe/consense < PCR_geno_consparam.in > PCR_geno_constree.phystdout" >> PCR_geno_cons_tree.sh
       

 
		sbatch -p high -t 2-00:00:00  PCR_geno_cons_tree.sh

		rm PCR_geno_cons_tree.sh

