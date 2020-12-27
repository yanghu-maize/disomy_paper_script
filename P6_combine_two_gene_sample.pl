#!/usr/bin/perl -w

$numArgs = @ARGV;
if($numArgs != 5)
{   
	print "the number of parameters is not correct!\n";
	exit(1);
}
# $ctrl_mapfile $trt_mapfile $ctrlname  $trtname $outfile
$ctrl_mapfile		= "$ARGV[0]"; #/group/birchler-cheng/Maize_mRNA-6SA/Experimental_group1.txt
$trt_mapfile = "$ARGV[1]"; 
$ctrlname	= "$ARGV[2]";
$trtname	= "$ARGV[3]";
$outfile	= "$ARGV[4]";


#### first get gene location 
$gff_file='/group/birchler-cheng/Maize_reference_genome_W22/Maize_reference_genome_W22_added_genename.gff3';
open(IN,"$gff_file") || die "Failed to write $gff_file\n";
%gene_loc = ();
while(<IN>)
{
  $l = $_;
  chomp $l;
  @tmp2 = split(/\t/,$l);
  $chr = $tmp2[0];
  $type = $tmp2[2];
  $start = $tmp2[3];
  $end = $tmp2[4];
  $info = $tmp2[8];
  if($type ne 'gene')
  {
    next;
  }
  @tmp3 = split(';',$info); #Name=Zm00004b002095;ID=53094;Alias=GRMZM2G0334
  $gene1 = $tmp3[0];
  @tmp4 = split('=',$gene1);
  $gene = $tmp4[1];
  if(exists($gene_loc{$gene}))
  {
    die "Duplicate gene $gene in $gff_file\n";
  }else{
    $gene_loc{$gene} = "$chr\t$start\t$end";
  }
  
}
close IN;


open(IN1,"$ctrl_mapfile") || die "Failed to write $ctrl_mapfile\n";
open(IN2,"$trt_mapfile") || die "Failed to write $trt_mapfile\n";
open(SH,">$outfile") || die "Failed to write $outfile\n";

%reads_combine=();


while(<IN1>)
{
  $l = $_;
  chomp $l;
  @tmp2 = split(/\t/,$l);
  $geneid = $tmp2[0];
  $reads = $tmp2[1];
  $reads_combine{$geneid} = $reads;
}
close IN1;



while(<IN2>)
{
  $l = $_;
  chomp $l;
  @tmp2 = split(/\t/,$l);
  $geneid = $tmp2[0];
  $reads = $tmp2[1];
  if(!exists($reads_combine{$geneid}))
  {
    die "$geneid not exists in $ctrl_mapfile\n";
  }
    
  
  $control_reads = $reads_combine{$geneid};
  if($control_reads ==0 or $reads==0)
  {
    $ratio = 0;
  }else{
    $ratio = $reads/$control_reads;
  }
  $reads_combine{$geneid} .= "\t$reads\t$ratio";
 
}
close IN2;


print SH "Chromosome\tStart\tEnd\tGeneId\tIndex\t$ctrlname\t$trtname\tRatio\n";
$indx=0;
foreach $geneid (sort keys %reads_combine)
{
  if(!exists($gene_loc{$geneid}))
  {
    die "Duplicate gene $gene in $gff_file\n";
  }
  $indx++;
  print SH $gene_loc{$geneid}."\t".$geneid."\t$indx\t".$reads_combine{$geneid}."\n";
}
close SH;



