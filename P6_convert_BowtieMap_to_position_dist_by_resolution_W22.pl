#!/usr/bin/perl -w
#define hash
use POSIX;
$numArgs = @ARGV;
if($numArgs != 4)
{   
	print "the number of parameters is not correct!";
	exit(1);
}

$mapfile = "$ARGV[0]"; #/exports/store1/soliman/Hua_Analysis/BirchlerJ_29_SOL/6SA21D_S1_R1_001_output_new_reference_by_jie/6SA21D_S1_R1_001_mismatch_2_unique.sam
$readslen = "$ARGV[1]";
$resolution = "$ARGV[2]";
$out = "$ARGV[3]";


###thi is for W22
$chr1_len=310925244;
$chr2_len=244237062;
$chr3_len=241278614;
$chr4_len=254269898;
$chr5_len=222590201;
$chr6_len=171602414;
$chr7_len=181422836;
$chr8_len=182570339;
$chr9_len=163066665;
$chr10_len=149450367;
$unmapped_len=12469099;



%position_reads_record=();

$chr1_seg = POSIX::ceil($chr1_len/$resolution);
print "chromosome 1 has length $chr1_len with $chr1_seg segment\n";
for($i=1;$i<=$chr1_seg;$i++)
{
	#print "$i\n";
	$id = 'chr1_'.$i;
	$position_reads_record{$id}=0;
}


$chr2_seg = POSIX::ceil($chr2_len/$resolution);
print "chromosome 2 has length $chr2_len with $chr2_seg segment\n";
for($i=1;$i<=$chr2_seg;$i++)
{
	#print "$i\n";
	$id = 'chr2_'.$i;
	$position_reads_record{$id}=0;
}

$chr3_seg = POSIX::ceil($chr3_len/$resolution);
print "chromosome 3 has length $chr3_len with $chr3_seg segment\n";
for($i=1;$i<=$chr3_seg;$i++)
{
	#print "$i\n";
	$id = 'chr3_'.$i;
	$position_reads_record{$id}=0;
}

$chr4_seg = POSIX::ceil($chr4_len/$resolution);
print "chromosome 4 has length $chr4_len with $chr4_seg segment\n";
for($i=1;$i<=$chr4_seg;$i++)
{
	#print "$i\n";
	$id = 'chr4_'.$i;
	$position_reads_record{$id}=0;
}

$chr5_seg = POSIX::ceil($chr5_len/$resolution);
print "chromosome 5 has length $chr5_len with $chr5_seg segment\n";
for($i=1;$i<=$chr5_seg;$i++)
{
	#print "$i\n";
	$id = 'chr5_'.$i;
	$position_reads_record{$id}=0;
}

$chr6_seg = POSIX::ceil($chr6_len/$resolution);
print "chromosome 6 has length $chr6_len with $chr6_seg segment\n";
for($i=1;$i<=$chr6_seg;$i++)
{
	#print "$i\n";
	$id = 'chr6_'.$i;
	$position_reads_record{$id}=0;
}

$chr7_seg = POSIX::ceil($chr7_len/$resolution);
print "chromosome 7 has length $chr7_len with $chr7_seg segment\n";
for($i=1;$i<=$chr7_seg;$i++)
{
	#print "$i\n";
	$id = 'chr7_'.$i;
	$position_reads_record{$id}=0;
}

$chr8_seg = POSIX::ceil($chr8_len/$resolution);
print "chromosome 8 has length $chr8_len with $chr8_seg segment\n";
for($i=1;$i<=$chr8_seg;$i++)
{
	#print "$i\n";
	$id = 'chr8_'.$i;
	$position_reads_record{$id}=0;
}

$chr9_seg = POSIX::ceil($chr9_len/$resolution);
print "chromosome 9 has length $chr9_len with $chr9_seg segment\n";
for($i=1;$i<=$chr9_seg;$i++)
{
	#print "$i\n";
	$id = 'chr9_'.$i;
	$position_reads_record{$id}=0;
}


$chr10_seg = POSIX::ceil($chr10_len/$resolution);
print "chromosome 10 has length $chr10_len with $chr10_seg segment\n";
for($i=1;$i<=$chr10_seg;$i++)
{
	#print "$i\n";
	$id = 'chr10_'.$i;
	$position_reads_record{$id}=0;
}

$unmapped_seg = POSIX::ceil($unmapped_len/$resolution);
print "chromosome else has length $unmapped_len with $unmapped_seg segment\n";
for($i=1;$i<=$unmapped_seg;$i++)
{
	#print "$i\n";
	$id = 'unmapped_'.$i;
	$position_reads_record{$id}=0;
}



print "\n**************************************************\n";
print "run getMulticomMapResults.pl\n";

open(IN1, "$mapfile") || die("Couldn't open file $mapfile\n");

%h3=();

print "Read gene length\n";
$k=0;
open(IN3, "$readslen") || die("Couldn't open file $readslen\n");
while ($l9 = <IN3>)
{
	chomp($l9);
	@i9=split(/\s++/,$l9);
	$reads=substr($i9[0],0,length($i9[0]));
	$len=$i9[1];
	$k++;
	if($k % 10000000 == 0)
	{
		print "$k finished\n";
	}
	#print $i9[0]."\n";
	#print $reads."\t$len\n\n";
	$h3{$reads}=1*$len;
}
close IN3;

open(OUT, ">$out") || die("Couldn't open file $out\n"); 

#print OUT "readname\tchromosome\tgene\tposition\tbegin\tend\n";

print "Read mapping results\n";
%pos_dist = ();
$num_pos = 0;
while ($line = <IN1>)
{
	if ("@" ne substr($line,0,1)) 
	{
		@i1=split(/\s++/,$line); #NB501332:92:HGM2KBGX2:1:11101:3383:1085 0       chr1       205003961   
	
		$readname=$i1[0];
		$chromosome=$i1[2];
		$position=1*$i1[3];
		if (exists($h3{$readname})) 
		{
			$len = $h3{$readname};
		}
		else
		{
			die "failed to find length for $readname\n";
		}
	}else{
		next;
	}
	
	$start = $position;
	$end = $position+$len;
	
	$start_round = POSIX::ceil($start/$resolution);
	$end_round = POSIX::ceil($end/$resolution);
	
	for($pos=$start_round;$pos<=$end_round;$pos++)
	{
		$mark = "${chromosome}_$pos";
		if(!exists($position_reads_record{$mark}))
		{
			print "$mark not exists with start: $start to end: $end at position: $position\n";
      next;
		}else{
			$position_reads_record{$mark}++;
			$num_pos++;
		}
		
		
		
		if($num_pos % 100000==0)
		{
			print "$num_pos has been marked\n";
		}
	}
}
close IN1;


#foreach $l (sort keys %position_reads_record)
#{
#	print OUT "$l\t".$position_reads_record{$l}."\n";
#}
#close OUT;






$chr1_seg = POSIX::ceil($chr1_len/$resolution);
print "chromosome 1 has length $chr1_len with $chr1_seg segment\n";
for($i=1;$i<=$chr1_seg;$i++)
{
	#print "$i\n";
	$id = 'chr1_'.$i;
	print OUT $id."\t".$position_reads_record{$id}."\t".$resolution."\n";
}


$chr2_seg = POSIX::ceil($chr2_len/$resolution);
print "chromosome 2 has length $chr2_len with $chr2_seg segment\n";
for($i=1;$i<=$chr2_seg;$i++)
{
	#print "$i\n";
	$id = 'chr2_'.$i;
	print OUT $id."\t".$position_reads_record{$id}."\t".$resolution."\n";
}

$chr3_seg = POSIX::ceil($chr3_len/$resolution);
print "chromosome 3 has length $chr3_len with $chr3_seg segment\n";
for($i=1;$i<=$chr3_seg;$i++)
{
	#print "$i\n";
	$id = 'chr3_'.$i;
	print OUT $id."\t".$position_reads_record{$id}."\t".$resolution."\n";
}

$chr4_seg = POSIX::ceil($chr4_len/$resolution);
print "chromosome 4 has length $chr4_len with $chr4_seg segment\n";
for($i=1;$i<=$chr4_seg;$i++)
{
	#print "$i\n";
	$id = 'chr4_'.$i;
	print OUT $id."\t".$position_reads_record{$id}."\t".$resolution."\n";
}

$chr5_seg = POSIX::ceil($chr5_len/$resolution);
print "chromosome 5 has length $chr5_len with $chr5_seg segment\n";
for($i=1;$i<=$chr5_seg;$i++)
{
	#print "$i\n";
	$id = 'chr5_'.$i;
	print OUT $id."\t".$position_reads_record{$id}."\t".$resolution."\n";
}

$chr6_seg = POSIX::ceil($chr6_len/$resolution);
print "chromosome 6 has length $chr6_len with $chr6_seg segment\n";
for($i=1;$i<=$chr6_seg;$i++)
{
	#print "$i\n";
	$id = 'chr6_'.$i;
	print OUT $id."\t".$position_reads_record{$id}."\t".$resolution."\n";
}

$chr7_seg = POSIX::ceil($chr7_len/$resolution);
print "chromosome 7 has length $chr7_len with $chr7_seg segment\n";
for($i=1;$i<=$chr7_seg;$i++)
{
	#print "$i\n";
	$id = 'chr7_'.$i;
	print OUT $id."\t".$position_reads_record{$id}."\t".$resolution."\n";
}

$chr8_seg = POSIX::ceil($chr8_len/$resolution);
print "chromosome 8 has length $chr8_len with $chr8_seg segment\n";
for($i=1;$i<=$chr8_seg;$i++)
{
	#print "$i\n";
	$id = 'chr8_'.$i;
	print OUT $id."\t".$position_reads_record{$id}."\t".$resolution."\n";
}

$chr9_seg = POSIX::ceil($chr9_len/$resolution);
print "chromosome 9 has length $chr9_len with $chr9_seg segment\n";
for($i=1;$i<=$chr9_seg;$i++)
{
	#print "$i\n";
	$id = 'chr9_'.$i;
	print OUT $id."\t".$position_reads_record{$id}."\t".$resolution."\n";
}


$chr10_seg = POSIX::ceil($chr10_len/$resolution);
print "chromosome 10 has length $chr10_len with $chr10_seg segment\n";
for($i=1;$i<=$chr10_seg;$i++)
{
	#print "$i\n";
	$id = 'chr10_'.$i;
	print OUT $id."\t".$position_reads_record{$id}."\t".$resolution."\n";
}

$unmapped_seg = POSIX::ceil($unmapped_len/$resolution);
print "chromosome unmapped has length $unmapped_len with $unmapped_seg segment\n";
for($i=1;$i<=$unmapped_seg;$i++)
{
	#print "$i\n";
	$id = 'unmapped_'.$i;
	print OUT $id."\t".$position_reads_record{$id}."\t".$resolution."\n";
}

close OUT;
