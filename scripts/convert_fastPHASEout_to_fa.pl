#!/usr/bin/perl

$file1 = $ARGV[0];

open(FILE, "<$file1") or die;

while (<FILE>) {

	$line = $_; chomp($line);
	if (substr($line,0,1) eq "#") {
		substr($line,0,1) = ""; ($line) = split(/\s/,$line);
		<FILE>;
		$line2 = <FILE>; $line2 =~ s/\x0/N/g; $line2 =~ s/ //g; $line2 =~ s/\[A\]/N/g; $line2 =~ s/\[C\]/N/g; $line2 =~ s/\[G\]/N/g; $line2 =~ s/\[T\]/N/g;
		$line3 = <FILE>; $line3 =~ s/\x0/N/g; $line3 =~ s/ //g; $line3 =~ s/\[A\]/N/g; $line3 =~ s/\[C\]/N/g; $line3 =~ s/\[G\]/N/g; $line3 =~ s/\[T\]/N/g;
		print ">$line" . "_a\n" . $line2;
		print ">$line" . "_b\n" . $line3;
	}

}
close FILE;


