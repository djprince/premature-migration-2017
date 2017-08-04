#!/bin/bash -l

mkdir genome/
mkdir genome/build/
cd genome/build/

#download scaffold and contigsNotScaffolded files from Berthelot et al (2014), combine, and remove unnecessary newlines and underscores
wget http://www.genoscope.cns.fr/trout/data/Oncorhynchus_mykiss_scaffolds.fa.gz
wget http://www.genoscope.cns.fr/trout/data/Oncorhynchus_mykiss_contigNotScaffolded.fa.gz
gunzip *gz
cat Oncorhynchus_mykiss_scaffolds.fa Oncorhynchus_mykiss_contigNotScaffolded.fa > Oncorhynchus_mykiss_scaffncontigs.fa  
perl ../../scripts/remove_newlines_from_fasta.pl Oncorhynchus_mykiss_scaffncontigs.fa > Oncorhynchus_mykiss_scaffncontigs_complete.fa
sed -i 's/_//g' Oncorhynchus_mykiss_scaffncontigs_complete.fa

#get scaffolds
grep -A 1 "scaffold79929$" Oncorhynchus_mykiss_scaffncontigs_complete.fa > scaffold79929.fa
grep -A 1 "scaffold18082$" Oncorhynchus_mykiss_scaffncontigs_complete.fa > scaffold18082.fa
grep -A 1 "scaffold31862$" Oncorhynchus_mykiss_scaffncontigs_complete.fa > scaffold31862.fa
grep -A 1 "scaffold68822$" Oncorhynchus_mykiss_scaffncontigs_complete.fa > scaffold68822.fa
grep -A 1 "scaffold5575$" Oncorhynchus_mykiss_scaffncontigs_complete.fa > scaffold5575.fa
grep -A 1 "scaffold35022$" Oncorhynchus_mykiss_scaffncontigs_complete.fa > scaffold35022.fa
grep -A 1 "scaffold79930$" Oncorhynchus_mykiss_scaffncontigs_complete.fa > scaffold79930.fa

# clean old assembly by removing scaffolds represented in 79929e
cp Oncorhynchus_mykiss_scaffncontigs_complete.fa Oncorhynchus_mykiss_scaffncontigs_cleaned.fa
sed -i -e '/>scaffold79929$/ { N; d; }' Oncorhynchus_mykiss_scaffncontigs_cleaned.fa 
sed -i -e '/>scaffold18082$/ { N; d; }' Oncorhynchus_mykiss_scaffncontigs_cleaned.fa 
sed -i -e '/>scaffold31862$/ { N; d; }' Oncorhynchus_mykiss_scaffncontigs_cleaned.fa 
sed -i -e '/>scaffold68822$/ { N; d; }' Oncorhynchus_mykiss_scaffncontigs_cleaned.fa 
sed -i -e '/>scaffold5575$/ { N; d; }' Oncorhynchus_mykiss_scaffncontigs_cleaned.fa 
sed -i -e '/>scaffold35022$/ { N; d; }' Oncorhynchus_mykiss_scaffncontigs_cleaned.fa 
sed -i -e '/>scaffold79930$/ { N; d; }' Oncorhynchus_mykiss_scaffncontigs_cleaned.fa 

#make Ngaps and idline
printf 'N%.0s' {1..551} > 551Ns
printf '\n' >> 551Ns
printf 'N%.0s' {1..920} > 920Ns
printf '\n' >> 920Ns
printf 'N%.0s' {1..284} > 284Ns
printf '\n' >> 284Ns
printf 'N%.0s' {1..10} > 10Ns
printf '\n' >> 10Ns
printf 'N%.0s' {1..1699} > 1699Ns
printf '\n' >> 1699Ns
printf '>scaffold79929e' > seqid
printf '\n' >> seqid

#combine scaffolds to build 79929e sequence, remove scaffold ids and newlines
cat scaffold79929.fa 551Ns scaffold18082.fa 920Ns scaffold31862.fa 284Ns scaffold68822.fa 10Ns scaffold5575.fa 1699Ns scaffold35022.fa 10Ns scaffold79930.fa | grep -v '>' | tr -d '\n' > scaffold79929e.seq

#add on new idline for fasta format
cat seqid scaffold79929e.seq > scaffold79929e.fa
printf '\n' >> scaffold79929e.fa

#combine new scaffold with cleaned old assembly, move up directory 
cat scaffold79929e.fa Oncorhynchus_mykiss_scaffncontigs_cleaned.fa > Oncorhynchus_mykiss_modified.fa
mv Oncorhynchus_mykiss_modified.fa ../
cd ../

#check md5sum
obs=$(md5sum Oncorhynchus_mykiss_modified.fa | awk '{print $1}')
exp="7017bdd04621d97580ae5099f65852f7"
echo "$obs   $exp"

#index for alignment
bwa index Oncorhynchus_mykiss_modified.fa

