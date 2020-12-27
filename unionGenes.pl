#!/usr/bin/perl -w
#define hash

$numArgs = @ARGV;
if($numArgs != 3)
{   
	print "the number of parameters is not correct!";
	exit(1);
}

$in1 = "$ARGV[0]";	#id
$in2 = "$ARGV[1]";	#multicom result
$out = "$ARGV[2]";	#output

print "\n**************************************************\n";
print "run unionGenes.pl\n";

open(IN, "$in1") || die("Couldn't read file $in1\n");  
@arr1=<IN>;
close IN;

open(IN, "$in2") || die("Couldn't read file $in2\n");  
@arr2=<IN>;
close IN;

open(OUT, ">$out") || die("Couldn't open file $out\n");

%h3=();
%h4=();
foreach $l2 (@arr2) 
{
	chomp($l2);
	@item2=split(/\t/,$l2);
	$id2=$item2[0];
	if(substr($id2,0,2) eq "AT"){
		if(length($id2)>=12 && substr($id2,11,1) eq "0"){
			$id2=substr($id2,0,12);
		}
		else{
			$id2=substr($id2,0,11);
		}
	}

	if (exists($h3{$id2})) 
	{
	}
	else
	{
		$h3{$id2}=$item2[1];
		$h4{$id2}=$item2[2];
	}
}

foreach $l1 (@arr1) 
{
	chomp($l1);
	$id1=$l1;
	if(substr($id1,0,2) eq "AT"){
		if(length($id1)>=12 && substr($id1,11,1) eq "0"){
			$id1=substr($id1,0,12);
		}
		else{
			$id1=substr($id1,0,11);
		}
	}

	$v1=0;
	$v2=0;

	if (exists($h3{$id1})) 
	{
		$v1=$h3{$id1};
		$v2=$h4{$id1};
	}

	print OUT $id1."\t";
	print OUT $v1."\t";
	print OUT $v2."\n";
}
close OUT;
