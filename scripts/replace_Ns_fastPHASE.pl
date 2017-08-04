#!/usr/bin/perl

$file1 = $ARGV[0];
$file2 = $ARGV[1];

open(FILE, "<$file1") or die;

while (<FILE>) {
	$name = $_; chomp($name);
	$seq = <FILE>; chomp($seq);
	@{$hash{$name}} = split(//,$seq);
}
close(FILE);


open(FILE, "<$file2") or die;

while (<FILE>) {
        $id = $_; chomp($id);
	($name, $copy) = split(/_/,$id);
        $seq = <FILE>; chomp($seq);
        @{$hash2{$name}} = split(//,$seq);

	$x = 0;
	while ($x <= scalar(@{$hash{$name}})) {
		if ($hash{$name}[$x] eq "N") {
			$hash2{$name}[$x] = "N";
		}
		$x++;
	}
	$seq = "@{$hash2{$name}}"; $seq =~ s/ //g;
	print "$id\n$seq\n"

}
close FILE;


