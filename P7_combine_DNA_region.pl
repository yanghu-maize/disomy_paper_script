$num = @ARGV;

if($num != 5)
{
	die "The number of parameter is not correct!\n";
}


$file1 = $ARGV[0];
$file2 = $ARGV[1];
$name1 = $ARGV[2];
$name2 = $ARGV[3];
$outputfile = $ARGV[4];

open(IN,"$file1") || die "Failed to open file $file1\n";
open(OUT,">$outputfile") || die "Failed to open file $outputfile\n"; 
%region_count = ();
print "Read the first file\n";
while(<IN>)
{
	$line=$_;
	chomp $line;
	@tmp = split(/\t/,$line);
	$region = $tmp[0];
	$count = $tmp[1];
	#$resolution = $tmp[2];
	$region_count{$region} = $count;
}
close IN;


open(IN,"$file2") || die "Failed to open file $file2\n";
print "Read the second file\n";
%region_count_common = ();
while(<IN>)
{
	$line=$_;
	chomp $line;
	@tmp = split(/\t/,$line);
	$region = $tmp[0];
	$count = $tmp[1];
	#$resolution = 100; # 100 for variable length unit
	if(exists($region_count{$region}))
	{
		@tmp2 = split('_',$region);
		$chr = $tmp2[0];
		$position = $tmp2[1];

		if($region_count{$region}==0 or  $count==0)
		{
			$ratio=0;
		}else{
			$ratio = sprintf("%.3f",$count/$region_count{$region});
		}
		print OUT "$chr\t$position\t".$region_count{$region}."\t".$count."\t$ratio\n";
		
		
	}	
}
close IN;
close OUT;
