#!/usr/bin/perl -w
#define hash

$numArgs = @ARGV;
if($numArgs != 2)
{   
	print "the number of parameters is not correct!";
	exit(1);
}

$mapfile = "$ARGV[0]";
$out = "$ARGV[1]";

print "\n**************************************************\n";
print "run getMulticomReadsCount.pl\n";

%h1=();
%h2=();
%h3=();

open(FILE, "$mapfile") || die("Couldn't open file $mapfile\n"); 
while ($line = <FILE>)
{
		chomp($line);
		@i=split(/\t/,$line);
		if (exists($h1{$i[0]})) 
		{
			$h1{$i[0]}++;
		}
		else
		{
			$h1{$i[0]}=1;
		}
}
close FILE;

open(FILE, "$mapfile") || die("Couldn't open file $mapfile\n"); 
while ($line = <FILE>)
{
		chomp($line);
		@i=split(/\t/,$line);
		if (exists($h2{$i[2]})) 
		{
			$h2{$i[2]}++;
		}
		else
		{
			$h2{$i[2]}=1;
		}

		if ($h1{$i[0]}==1) 
		{
			if (exists($h3{$i[2]})) 
			{
				$h3{$i[2]}++;
			}
			else
			{
				$h3{$i[2]}=1;
			}
		}
}
close FILE;

open(OUT, ">$out") || die("Couldn't open file $out\n"); 
while(my ($key, $val) = each(%h2)) 
{ 
	if (exists($h3{$key}))
	{
		print OUT $key."\t".$val."\t".$h3{$key}."\n";
	}
	else
	{
		print OUT $key."\t".$val."\t0\n";
	}
}
close OUT;
