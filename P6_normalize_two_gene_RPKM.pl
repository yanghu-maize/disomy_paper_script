#!/usr/bin/perl -w
#define hash

$numArgs = @ARGV;

if($numArgs != 2)
{   
        print "the number of parameters is not correct!";
        exit(1);
}

$in                     = "$ARGV[0]";
$out            = "$ARGV[1]";
$num_sample     = 2;

print "\n**************************************************\n";
print "run normalize_RPKM.pl\n";

#%h1=();

#print SH "Chromosome\tStart\tEnd\tGeneId\tIndex\t$ctrlname\t$trtname\tRatio\n";

open(IN, "$in") || die("Couldn't read file $in\n");  
@arr1=<IN>;
close IN;

open(OUT, ">$out") || die("Couldn't open file $out\n");

@total=();

for ($i=0; $i<$num_sample; $i++) {
        $total[$i]=0;
}

$c=0;
foreach $l1 (@arr1){
      chomp($l1);
      $c++;
      if($c==1)
      {
        next;
      }
      @item1=split(/\t/,$l1);

      for ($i=0; $i<$num_sample; $i++) {
              $total[$i]+=$item1[5+$i]; #  start from 5 column
      }
        
}

$c=0;
foreach $l1 (@arr1){
      chomp($l1);
      $c++;
      if($c==1)
      {
        print OUT "$l1\n";
        next;
      }
      @item1=split(/\t/,$l1);

      print OUT $item1[0]."\t".$item1[1]."\t".$item1[2]."\t".$item1[3]."\t".$item1[4];
      $norLen = $item1[2]-$item1[1]+1;
      #RPKM = reads per kilobase per million
      #= [# of mapped reads]/([length of transcript]/1000)/([total reads]/10^6)
      $count_save="";
      for ($i=0; $i<$num_sample; $i++) {
              $k=1000000*$item1[5+$i]*1000/$total[$i]/$norLen;#  start from 5 column
              print OUT "\t".$k; 
              $count_save .="\t".$k;
      }
      $count_save = substr($count_save,1);
      @count_save_array= split(/\t/,$count_save);
      if($count_save_array[0]==0)
      {
        $count_save_array[0]=1;
      }
      $ratio = sprintf("%.3f",$count_save_array[1]/$count_save_array[0]);

      print OUT "\t$ratio\n";
        
}
close OUT;
