#!/usr/bin/perl -w
#define hash

# calculate the number of reads mapping to single position, multiple positions

$numArgs = @ARGV;
if($numArgs != 1)
{   
	print "the number of parameters is not correct!";
	exit(1);
}

$mapfile = "$ARGV[0]";

open(FILE, "$mapfile") || die("Couldn't open file $mapfile\n"); 

%h=();
while ($line = <FILE>){
	if (substr($line,0,1) ne "@"){
		@i=split(/\t/,$line);
		if (exists($h{$i[0]})){
			$h{$i[0]}++;
		}
		else{
			$h{$i[0]}=1;
		}
	}
}
close FILE;

$y=0;
$n=0;
while(my ($key, $val) = each(%h)){ 
	if ($val==1){
		$y++;
	}
	else{
		$n++;
	} 
}
#$s=$y+$n;
#print $y."\t".$n."\t".$s."\n";
print $y."\n";
print $n."\n";

