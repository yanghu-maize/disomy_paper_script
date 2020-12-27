#!/usr/bin/perl -w

$numArgs = @ARGV;
if($numArgs != 1)
{   
	print "the number of parameters is not correct!";
	exit(1);
}

$mapfile = "$ARGV[0]";

open(FILE, "$mapfile") || die("Couldn't open file $mapfile\n"); 

$c=0;
while ($line = <FILE>){
	chomp($line);
	$c++;
}
close FILE;

$k=$c/4;
print $k."\n";

