#!/usr/bin/perl

$file1 = $ARGV[0];

open(FILE, "<$file1") or die;

while (<FILE>) {

	$line = $_;

	if (substr($line, 0, 1) eq ">") {
		substr($line, 0, 1) = "#";
		$line2 = <FILE>;
		$line3 = $line2;
		$line2 =~ s/R/A/g; $line2 =~ s/Y/C/g; $line2 =~ s/S/G/g; $line2 =~ s/W/A/g; $line2 =~ s/K/G/g; $line2 =~ s/M/A/g; $line2 =~ s/N/?/g;
		$line3 =~ s/R/G/g; $line3 =~ s/Y/T/g; $line3 =~ s/S/C/g; $line3 =~ s/W/T/g; $line3 =~ s/K/T/g; $line3 =~ s/M/C/g; $line3 =~ s/N/?/g;
		print $line . $line2 . $line3;
	}
}
close FILE;


