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
$input_res = "$ARGV[1]";
$output_res = "$ARGV[2]";
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


print "\n**************************************************\n";
open(OUT, ">$out") || die("Couldn't open file $out\n"); 

$segment = $output_res/$input_res; # evert segment to count the value

open(IN1, "$mapfile") || die("Couldn't open file $mapfile\n");
$batch=0;
%log_chr=();
$batch=0;
$previous_chr="";
$num_pos=0;
while(<IN1>)
{
	$line=$_;
	chomp $line;
	@tmp=split(/\t/,$line);
	$chr_pos=$tmp[0];
	$read_count=$tmp[1];
	@tmp2=split(/\_/,$chr_pos);
	$chr = $tmp2[0];
	$pos = $tmp2[1];
	if(!exists($log_chr{$chr})) # for each chromosome, recount
	{
		if(keys %log_chr >=1) # means the previous chromosome has finished, check if last batch has been record 
		{
			if(!exists($position_reads_record{"${previous_chr}_$batch"}))
			{
				$position_reads_record{"${previous_chr}_$batch"} = $count_all;
			}
		}
		$batch=0;
		$log_chr{$chr}=1;
		$previous_chr=$chr;
	}
	if($pos % $segment ==1) #start with 1
	{
		
		if($batch >=1) # already process one 
		{
			$position_reads_record{"${chr}_$batch"} = $count_all;
		}
		$count_all=$read_count; # reinitialize count
		$batch++;
		next;
	}else{
		$count_all += $read_count;
	}
		
	if($num_pos % 100000==0)
	{
		print "$num_pos has been marked\n";
	}
	$num_pos++;
		
}
close IN1;
### record last batch
if(!exists($position_reads_record{"${previous_chr}_$batch"}))
{
	$position_reads_record{"${previous_chr}_$batch"} = $count_all;
}


$chr1_seg = POSIX::ceil($chr1_len/$output_res);
print "chromosome 1 has length $chr1_len with $chr1_seg segment\n";
for($i=1;$i<=$chr1_seg;$i++)
{
	#print "$i\n";
	$id = 'chr1_'.$i;
	if(!exists($position_reads_record{$id}))
	{
		print "couldn't find ".$id."\n";
		next;
	}
	print OUT $id."\t".$position_reads_record{$id}."\t".$output_res."\n";
}


$chr2_seg = POSIX::ceil($chr2_len/$output_res);
print "chromosome 2 has length $chr2_len with $chr2_seg segment\n";
for($i=1;$i<=$chr2_seg;$i++)
{
	#print "$i\n";
	$id = 'chr2_'.$i;
	if(!exists($position_reads_record{$id}))
	{
		#print "couldn't find ".$id."\n";
		next;
	}
	print OUT $id."\t".$position_reads_record{$id}."\t".$output_res."\n";
}

$chr3_seg = POSIX::ceil($chr3_len/$output_res);
print "chromosome 3 has length $chr3_len with $chr3_seg segment\n";
for($i=1;$i<=$chr3_seg;$i++)
{
	#print "$i\n";
	$id = 'chr3_'.$i;
	if(!exists($position_reads_record{$id}))
	{
		#print "couldn't find ".$id."\n";
		next;
	}
	print OUT $id."\t".$position_reads_record{$id}."\t".$output_res."\n";
}

$chr4_seg = POSIX::ceil($chr4_len/$output_res);
print "chromosome 4 has length $chr4_len with $chr4_seg segment\n";
for($i=1;$i<=$chr4_seg;$i++)
{
	#print "$i\n";
	$id = 'chr4_'.$i;
	if(!exists($position_reads_record{$id}))
	{
		#print "couldn't find ".$id."\n";
		next;
	}
	print OUT $id."\t".$position_reads_record{$id}."\t".$output_res."\n";
}

$chr5_seg = POSIX::ceil($chr5_len/$output_res);
print "chromosome 5 has length $chr5_len with $chr5_seg segment\n";
for($i=1;$i<=$chr5_seg;$i++)
{
	#print "$i\n";
	$id = 'chr5_'.$i;
	if(!exists($position_reads_record{$id}))
	{
		#print "couldn't find ".$id."\n";
		next;
	}
	print OUT $id."\t".$position_reads_record{$id}."\t".$output_res."\n";
}

$chr6_seg = POSIX::ceil($chr6_len/$output_res);
print "chromosome 6 has length $chr6_len with $chr6_seg segment\n";
for($i=1;$i<=$chr6_seg;$i++)
{
	#print "$i\n";
	$id = 'chr6_'.$i;
	if(!exists($position_reads_record{$id}))
	{
		#print "couldn't find ".$id."\n";
		next;
	}
	print OUT $id."\t".$position_reads_record{$id}."\t".$output_res."\n";
}

$chr7_seg = POSIX::ceil($chr7_len/$output_res);
print "chromosome 7 has length $chr7_len with $chr7_seg segment\n";
for($i=1;$i<=$chr7_seg;$i++)
{
	#print "$i\n";
	$id = 'chr7_'.$i;
	print OUT $id."\t".$position_reads_record{$id}."\t".$output_res."\n";
}

$chr8_seg = POSIX::ceil($chr8_len/$output_res);
print "chromosome 8 has length $chr8_len with $chr8_seg segment\n";
for($i=1;$i<=$chr8_seg;$i++)
{
	#print "$i\n";
	$id = 'chr8_'.$i;
	if(!exists($position_reads_record{$id}))
	{
		#print "couldn't find ".$id."\n";
		next;
	}
	print OUT $id."\t".$position_reads_record{$id}."\t".$output_res."\n";
}

$chr9_seg = POSIX::ceil($chr9_len/$output_res);
print "chromosome 9 has length $chr9_len with $chr9_seg segment\n";
for($i=1;$i<=$chr9_seg;$i++)
{
	#print "$i\n";
	$id = 'chr9_'.$i;
	if(!exists($position_reads_record{$id}))
	{
		#print "couldn't find ".$id."\n";
		next;
	}
	print OUT $id."\t".$position_reads_record{$id}."\t".$output_res."\n";
}


$chr10_seg = POSIX::ceil($chr10_len/$output_res);
print "chromosome 10 has length $chr10_len with $chr10_seg segment\n";
for($i=1;$i<=$chr10_seg;$i++)
{
	#print "$i\n";
	$id = 'chr10_'.$i;
	if(!exists($position_reads_record{$id}))
	{
		#print "couldn't find ".$id."\n";
		next;
	}
	print OUT $id."\t".$position_reads_record{$id}."\t".$output_res."\n";
}

$unmapped_seg = POSIX::ceil($unmapped_len/$output_res);
print "chromosome unmapped has length $unmapped_len with $unmapped_seg segment\n";
for($i=1;$i<=$chrMt_seg;$i++)
{
	#print "$i\n";
	$id = 'unmapped_'.$i;
	if(!exists($position_reads_record{$id}))
	{
		#print "couldn't find ".$id."\n";
		next; 
	}
	print OUT $id."\t".$position_reads_record{$id}."\t".$output_res."\n";
}
close OUT;
