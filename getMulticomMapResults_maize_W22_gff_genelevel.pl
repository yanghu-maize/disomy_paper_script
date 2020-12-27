#!/usr/bin/perl -w
#define hash

$numArgs = @ARGV;
if($numArgs != 4)
{   
	print "the number of parameters is not correct!";
	exit(1);
}

$mapfile = "$ARGV[0]";
$genefile = "$ARGV[1]";
$readslen = "$ARGV[2]";
$out = "$ARGV[3]";

print "\n**************************************************\n";
print "run getMulticomMapResults.pl\n";

open(IN1, "$mapfile") || die("Couldn't open file $mapfile\n");

open(IN2, "$genefile") || die("Couldn't open file $genefile\n"); 
@agene=<IN2>;
close IN2;

%h1=();
%h2=();
%h3=();
$c=0;
$c99=0;

print "Read gene annotation\n";
foreach $l (@agene) 
{
	@i=split(/\t/,$l);
	if (exists($h1{$i[0]})) 
	{
	}
	else
	{
		$h1{$i[0]}=$c;
	}
	$h2{$i[0]}=$c;
	$c++;
	$c99++;
	
}

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
while ($line = <IN1>)
{
	if ("@" ne substr($line,0,1)) 
	{
		@i1=split(/\s++/,$line);
	
		$readname=$i1[0];
		$chromosome=$i1[2];
		$position=1*$i1[3];

		if (exists($h1{$chromosome})) 
		{
		}
		else
		{
			next;
		}

		$a=1*$h1{$chromosome};
		$b=1*$h2{$chromosome};

		while ($b>=$a) 
		{
			$k=$a+int(($b-$a)/2);
			
			$l2=$agene[$k];
			@i2=split(/\t/,$l2);

			$chromosome2=$i2[0];
			$begin=1*$i2[3];
			$end=1*$i2[4];

			if ($position<$begin) 
			{
				$b=$k-1;
				next;
			}
			if ($position>$end) 
			{
				$a=$k+1;
				next;
			}
			if (($chromosome eq $chromosome2) && ($position>=$begin) && ($position<=$end)) 
			{
				$m=$k;
				$n=$k+1;
				
				if ($m>=$a) 
				{
					while(1)
					{
						$l3=$agene[$m];
						@i3=split(/\s++/,$l3);

						$gene1=$i3[8];
						@i22=split(/;/,$gene1); #Name=Zm00004b000001;ID=12;Alias=Zm00001d027230
						$gene2=$i22[0]; # Name=Zm00004b000001
						@i23=split('=',$gene2);
	
            if(@i23 !=2)
            {
              die "Gene $gene1 has wrong format\n";
            }
						$gene=$i23[1]; 
						#print ">: $gene\n";
						$chromosome2=$i3[0];
						$begin=1*$i3[3];
						$end=1*$i3[4];

						$kkk=1*$h3{$readname};

						if (($chromosome eq $chromosome2) && ($position>=$begin) && (($position+$kkk-1)<=$end)) 
						#if (($chromosome eq $chromosome2) && ($position>=$begin) && ($position<=$end))
						{
							print OUT "$readname\t$chromosome\t$gene\t$position\t$begin\t$end\n";
						}
						else
						{
							last;
						}
						$m=$m-1;
					}
				}

				if ($n<=$b) 
				{
					while(1)
					{
						if ($n>=$c99 || $n<0) 
						{
							last;
						}

						if (length($agene[$n])<=1) 
						{
							last;
						}

						$l4=$agene[$n];

						@i4=split(/\s++/,$l4);

						$gene1=$i4[8];
						@i22=split(/;/,$gene1); #Name=Zm00004b000001;ID=12;Alias=Zm00001d027230
						$gene2=$i22[0]; # Name=Zm00004b000001
						@i23=split('=',$gene2);
            if(@i23 !=2)
            {
              die "Gene $gene1 has wrong format\n";
            }
						$gene=$i23[1];  
						#print ">: $gene\n";
						$chromosome2=$i4[0];
						$begin=1*$i4[3];
						$end=1*$i4[4];

						$kkk=1*$h3{$readname};

						if (($chromosome eq $chromosome2) && ($position>=$begin) && (($position+$kkk-1)<=$end)) 
						#if (($chromosome eq $chromosome2) && ($position>=$begin) && ($position<=$end))
						{
							print OUT "$readname\t$chromosome\t$gene\t$position\t$begin\t$end\n";
						}
						else
						{
							last;
						}
						$n=$n+1;
					}
				}
				last;
			}

		}
	}
}
close IN1;
close OUT;
