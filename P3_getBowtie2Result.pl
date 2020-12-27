#!/usr/bin/perl -w


#perl getBowtie2Result.pl 
$numArgs = @ARGV;
if($numArgs != 3)
{   
	print "the number of parameters is not correct!";
	exit(1);
}

$in = "$ARGV[0]";
$out = "$ARGV[1]";
$mismatch = "$ARGV[2]";

open(OUT, ">$out") || die("Couldn't open file $out\n"); 
open(IN2, "$in") || die("Couldn't open file $in\n"); 

$num_all = 0;
$num_filter = 0;
while ($line = <IN2>)
{
	chomp($line);
	
	if (substr($line,0,1) eq "@") {
		print OUT $line."\n";;
	}
	$num_all++;
	@i0=split(/\s++/,$line);

	if(($num_all % 1000000)==0)
	{
		print "$num_all finished!\n";
	}
	foreach $lk (@i0) 
	{
		#XM:i:<N>	The number of mismatches in the alignment. Only present if SAM record is for an aligned read.
		if($mismatch == 0)
		{
			if ($lk eq "XM:i:0") 
			{
				print OUT $line."\n";
				$num_filter++;
				last;
			}
		}
		elsif($mismatch == 1)
		{
			if ($lk eq "XM:i:1" || $lk eq "XM:i:0") 
			{
				print OUT $line."\n";
				$num_filter++;
				last;
			}
		}
		elsif($mismatch == 2)
		{
			if ($lk eq "XM:i:2" || $lk eq "XM:i:1" || $lk eq "XM:i:0") 
			{
				print OUT $line."\n";
				$num_filter++;
				last;
			}
		}
	}
}

close IN2;
close OUT;


print "Reads filtered from $num_all to $num_filter\n";
