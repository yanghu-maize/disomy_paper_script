#!/usr/bin/perl -w

$numArgs = @ARGV;
if($numArgs != 2)
{   
	print "the number of parameters is not correct!";
	exit(1);
}

$infile = "$ARGV[0]";
$outfile = "$ARGV[1]";

print "\n**************************************************\n";
print "run getReadsLength.pl\n";

open(FILE, "$infile") || die("Couldn't read file $infile\n");  
open(OUT, ">>$outfile") || die("Couldn't read file $outfile\n");  

$c=0;
while ($line = <FILE>)
{
	$c++;
	if (($c%4)==1) 
	{
		chomp($line);
		print OUT substr($line,1,index($line," "));
	}
	if (($c%4)==2) 
	{
		chomp($line);
		print OUT "\t".length($line)."\n";
	}
}
close FILE;
close OUT;
