#!/usr/bin/perl

$file = $ARGV[0];

open(FILE, "<$file");

while(<FILE>){
	$line = $_; chomp($line);
	@tabs = split(/\t/, $line);
	$hash{$tabs[0]}{$tabs[1]} = $tabs[2];
	$hash{$tabs[1]}{$tabs[0]} = $tabs[2];
	$hash{$tabs[0]}{$tabs[0]} = "NA";
        $hash{$tabs[1]}{$tabs[1]} = "NA";

}
close FILE;
$head = "Pop\t";
foreach $key1 (sort keys %hash) {
	$head = $head . "$key1\t";
	foreach $key2 (sort keys %{ $hash{$key1} }) {
		$line{$key1} = $line{$key1} . "\t$hash{$key1}{$key2}";
	}
	
}
chop($head);
print "$head\n";
foreach $key1 (sort keys %line) {
	print $key1 . "$line{$key1}\n";
}	
