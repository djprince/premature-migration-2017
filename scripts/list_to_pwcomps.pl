#!/usr/bin/perl

$file = $ARGV[0];
open(FILE, "<$file")
	or die;
$x=0;
while (<FILE>) {
	$line = $_; chomp $line;
	$array[$x] = $line;
	$x++;
}
close FILE;
$z = 0;
while ($z < $x) {
	$y=$z;
	while ($y < $x) {
		if ($z != $y) {	print "$array[$z]\t$array[$y]\n"; } $y++;
	}
	$z++;
}
