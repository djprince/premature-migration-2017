#!/usr/bin/perl
$file = $ARGV[0];

open(FILE, "<$file")
        or die;
#first line will be idline
$line = <FILE>; print $line;

while (<FILE>) {

	$line = $_;
	
	if (substr($line,0,1) eq '>')  { #if idline
		print "\n$line";
	}
	else {
		chomp $line;
		print $line;
	} 

}
close FILE;

