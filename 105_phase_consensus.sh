#!/bin/bash -l
#SBATCH -t 5-00:00:00


	mkdir PCR_phase/

	scripts/bamlist_to_subpop.sh consensus/St.bamlist St > PCR_phase/St.subpoplist	
#convert biallelic cons fasta to fastPHASE input file (*.inp)
		scripts/convert_fa_to_fastPHASEinp.pl PCR_genos/PCR_geno_cons.fa > PCR_phase/PCR_geno_cons.inp_body
		grep "#" PCR_phase/PCR_geno_cons.inp_body | wc -l | awk '{print $1}' > PCR_phase/PCR_geno_cons.inp_numind
		numbp=$(head -n 2 PCR_phase/PCR_geno_cons.inp_body | tail -n 1 | wc | awk '{print $3}')
		numbp=$(($numbp - 1 ))
		echo "$numbp" > PCR_phase/PCR_geno_cons.inp_numbp 
		cat PCR_phase/PCR_geno_cons.inp_numind PCR_phase/PCR_geno_cons.inp_numbp PCR_phase/PCR_geno_cons.inp_body > PCR_phase/PCR_geno_cons.inp
		rm PCR_phase/PCR_geno_cons.inp_body PCR_phase/PCR_geno_cons.inp_numind PCR_phase/PCR_geno_cons.inp_numbp
mkdir PCR_phase/PCR_geno_cons_fastPHASE/

#fastPHASE (1000 reps)
#convert 1000 fastphase outputs to 1000 fasta
	echo "#!/bin/bash
job=\$SLURM_ARRAY_TASK_ID
			mkdir  PCR_phase/PCR_geno_cons_fastPHASE/\${job}/
			cd PCR_phase/PCR_geno_cons_fastPHASE/\${job}/
			srun fastPHASE -q0.80 -u../../St.subpoplist ../../PCR_geno_cons.inp
			convert_fastPHASEout_to_fa1.pl fastphase_hapguess_switch.out > PCR_geno_cons_fPout_\${job}.fa
			convert_fastPHASE_fa1_to_fa2.pl ../../../consensus/PCR_geno_cons.fa PCR_geno_cons_fPout_\${job}.fa > PCR_geno_cons_fPout_\${job}.fa_2
			cd .." >> phase_PCR_geno_cons.sh

		sbatch -p low --array=1-1000 -t 6-00:00:00 phase_PCR_geno_cons.sh
		rm phase_PCR_geno_cons.sh
