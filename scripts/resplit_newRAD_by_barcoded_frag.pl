#!/usr/bin/perl

$r1in = $ARGV[0];
$r1out = $ARGV[1];
$r2in = $ARGV[2];
$r2out = $ARGV[3];

open(R1IN, "<$r1in") or die;
open(R1OUT, ">$r1out");
open(R2IN, "<$r2in") or die;
open(R2OUT, ">$r2out");
if(index($r1in,"SOMM064") != -1) { ##checks if library prep method was newRAD by SOMM ID
	while (<R1IN>) {
		$id_1 = $_; chomp $id_1;
		$seq_1 = <R1IN>;chomp $seq_1;
		$id2_1 = <R1IN>;chomp $id2_1;
		$qual_1 = <R1IN>; chomp $qual_1;
		
		$id_2 = <R2IN>; chomp $id_2;
                $seq_2 = <R2IN>;chomp $seq_2;
                $id2_2 = <R2IN>;chomp $id2_2;
                $qual_2 = <R2IN>; chomp $qual_2;

		if(length($seq_1) < length($seq_2)) { #if barcode was on R1
			print R1OUT "$id_1\n$seq_1\n$id2_1\n$qual_1\n";
			print R2OUT "$id_2\n$seq_2\n$id2_2\n$qual_2\n";
		}	
		else {
			print R1OUT "$id_2\n$seq_2\n$id2_2\n$qual_2\n";
			print R2OUT "$id_1\n$seq_1\n$id2_1\n$qual_1\n";
		}
	}
}
close R1IN; close R1OUT; close R2IN; close R2OUT;
