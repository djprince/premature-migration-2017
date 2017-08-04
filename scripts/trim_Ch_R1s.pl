#!/usr/bin/perl

#trim Chinook read1 seqs to 75bases

$file = $ARGV[0]; chomp($file);
$r1in = "RAD_sequence/" . $file . "_R1.fastq";
$r1out = "RAD_sequence/" . $file . "_75_R1.fastq";
open(R1IN, "<$r1in") or die;
open(R1OUT, ">$r1out");
if(index($file,"SOMM064") != -1) { ##checks if library prep method was newRAD by SOMM ID
	while (<R1IN>) {
		$id = $_; chomp $id;
		$id = $id . " (trim75)";
		$seq = <R1IN>;chomp $seq;
		$id2 = <R1IN>;chomp $id2;
		$id2 = $id2 . " (trim75)";
		$qual = <R1IN>; chomp $qual;
		$seq_trim = substr($seq, 5, (length($seq)-9));
		$qual_trim = substr($qual, 5, (length($seq)-9));
		print R1OUT "$id\n$seq_trim\n$id2\n$qual_trim\n";
	}
}
else { #not newRAD, (tradRAD)
	while (<R1IN>) {
		$id = $_; chomp $id;
		$id = $id . " (trim75)";
		$seq = <R1IN>;chomp $seq;
		$id2 = <R1IN>;chomp $id2;
		$id2 = $id2 . " (trim75)";
		$qual = <R1IN>; chomp $qual;
		$seq_trim = substr($seq, 5, (length($seq)-13));
		$qual_trim = substr($qual, 5, (length($seq)-13));
		print R1OUT "$id\n$seq_trim\n$id2\n$qual_trim\n";
	}
}
close R1IN; close R1OUT;
