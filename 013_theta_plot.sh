#!/bin/bash -l
#SBATCH -o 13_theta_plot-%j.out
echo "emp" > RAD_thetas/Ump_emp.txt
grep Ump RAD_thetas/RAD_thetas.txt | awk '{print $7"\n"$6}' >> RAD_thetas/Ump_emp.txt

paste RAD_thetas/Ump_CIs.txt RAD_thetas/Ump_emp.txt > RAD_thetas/Ump.Rinput

Rscript --slave --vanilla scripts/plot_thetas.R Ump.Rinput

