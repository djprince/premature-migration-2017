#!/usr/bin/perl
system("mkdir RAD_samples");
open(FILE, "<metadata/RADseqID_DNAID.list") or die;
while (<FILE>) {
	$line = $_; chomp($line);
	@tabs = split(/\t/,$line);
	$hash{$tabs[1]} = $hash{$tabs[1]} . "RAD_alignments/$tabs[0]_sorted_proper_rmdup.bam ";
}
close FILE;

foreach $key (sort (keys(%hash))) {
	print "$key\t$hash{$key}\n";
	open(FILE, ">$key.sh");
	print FILE "#!/bin/bash\n";
	print FILE "#SBATCH -o RAD_samples/${key}-%j.out\n";
	if(length($hash{$key}) > 90) { ##(ie more than one bam file)
		print FILE "samtools merge RAD_samples/${key}.bam $hash{$key}\n";
	}
	else {
		print FILE "cp $hash{$key} RAD_samples/${key}.bam\n";
	}
	print FILE "samtools index RAD_samples/${key}.bam RAD_samples/${key}.bam.bai\n";
	print FILE "samtools view -c RAD_samples/${key}.bam > RAD_samples/${key}.count\n";
	close FILE;
	system("sbatch -J radmer $key.sh");
	system("rm $key.sh");
}
