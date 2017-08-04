#!/usr/bin/perl

$bamlist = $ARGV[0];
$geno_file = $ARGV[1];
$cons_type = $ARGV[2]; #[enter 1 for merged or 2 for seperate]

if ($#ARGV != 2 ) { print "oops!\n\$bamlist = \$ARGV[0];\n\$geno_file = \$ARGV[1];\n\$cons_type = \$ARGV[2]; #[enter1 for merged and 2 for seperate]\n"; die;}



open(FILE, "<$bamlist") or die;
$x=0;
while (<FILE>) {
	$line = $_; chomp($line);
        $line =~ s/^.*St_//;
        $line =~ s/_pcr_.*//;
        $line =~ s/_//;   
        $line =~ s/_(?=[^_]*$)//; 
	$id[$x] = $line;
	$x++;
}
close FILE;

open(FILE, "<$geno_file") or die;
while (<FILE>) {
        $line = $_; chomp($line);
	@tabs = split(/\t/, $line);
	$x=0;
	$pos{$tabs[1]}=1;
	while($x < ($#tabs-1)) {
		$genos{$id[$x]}[$tabs[1]] = $tabs[$x+2];
		$x++;
	}
}
close FILE;

foreach $ind (keys %genos) {
	$cons1 = "";
	$cons2 = "";
	$cons3 = "";
	foreach $site (sort {$a <=> $b} keys %pos) {
		$a1 = substr($genos{$ind}[$site],0,1);
		$a2 = substr($genos{$ind}[$site],1,1);
		if ($a1 eq $a2 ) { 
			$a3 = $a1;
		}
		elsif($genos{$ind}[$site] eq "AT" || $genos{$ind}[$site] eq "TA") {
			$a3 = "W";
		}
		elsif($genos{$ind}[$site] eq "AC" || $genos{$ind}[$site] eq "CA") {
                        $a3 = "M";
                }
		elsif($genos{$ind}[$site] eq "AG" || $genos{$ind}[$site] eq "GA") {
                        $a3 = "R";
                }
		elsif($genos{$ind}[$site] eq "CT" || $genos{$ind}[$site] eq "TC") {
                        $a3 = "Y";
                }
		elsif($genos{$ind}[$site] eq "GT" || $genos{$ind}[$site] eq "TG") {
                        $a3 = "K";
                }
		elsif($genos{$ind}[$site] eq "GC" || $genos{$ind}[$site] eq "CG") {
                        $a3 = "S";
                }
		$cons1 = $cons1 . $a1;
		$cons2 = $cons2 . $a2;
		$cons3 = $cons3 . $a3;

	}
	if($cons_type == 2) { print ">$ind" . "_1\n$cons1\n>$ind" . "_2\n$cons2\n"; }
	elsif($cons_type == 1 ) { print ">$ind\n$cons3\n"; }
}
