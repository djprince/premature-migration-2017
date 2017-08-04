#!/usr/bin/perl
#script pulls R1s and merges 

system("awk '{print \$1}' metadata/RADseqID_DNAID.list > seq.list");
open(SEQ, "<seq.list") or die;
while (<SEQ>) {
        $line = $_; chomp($line);
	@tabs = split(/\t/,$line);
	$file = $tabs[0];
	$samin = "RAD_alignments/" . $file . "_75_sorted_proper_rmdup.sam";
	$out = "RAD_alignments/" . $file . "_75_R1";
	open(SAMIN, "<$samin") or die;
	open(SAMOUT, ">$out.sam");

	while (<SAMIN>) {
		$line = $_; chomp $line;
		if (substr($line,0,1) ne "\@") {
			@tabs = split(/\t/, $line);
			if (length($tabs[9]) == 75) {
				print SAMOUT "$line\n";
			}
		}
		else {print SAMOUT "$line\n";}
	}

	close SAMIN; close SAMOUT;
	system("samtools view -bS $out.sam > $out.bam");
	system("samtools sort $out.bam ${out}_sorted");
	system("samtools index ${out}_sorted.bam ${out}_sorted.bam.bai");
}
close SEQ;
system("rm seq.list");

open(FILE, "<metadata/RADseqID_DNAID.list") or die;
while (<FILE>) {
        $line = $_; chomp($line);
        @tabs = split(/\t/,$line);
	$id = $tabs[1] . "_75_R1";
        $hash{$id} = $hash{$id} . "RAD_alignments/$tabs[0]_75_R1_sorted.bam ";
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
        else{
                print FILE "cp $hash{$key} RAD_samples/${key}.bam\n";
        }

	print FILE "samtools index RAD_samples/${key}.bam RAD_samples/${key}.bam.bai\n";
        print FILE "samtools view -c RAD_samples/${key}.bam > RAD_samples/${key}.count";
        close FILE;
        system("sbatch -J radmer $key.sh");
        system("rm $key.sh");
}

