#!/usr/bin/perl -w
#define hash

$numArgs = @ARGV;

if($numArgs != 4)
{   
        print "the number of parameters is not correct!";
        exit(1);
}

$in                     = "$ARGV[0]";
$out            = "$ARGV[1]";
$norLen        = "$ARGV[2]";
$num_sample     = "$ARGV[3]";

print "\n**************************************************\n";
print "run normalize_RPKM.pl\n";

#%h1=();


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
      @item1=split(/\t/,$l1);

      for ($i=0; $i<$num_sample; $i++) {
              $total[$i]+=$item1[2+$i];
      }
        
}

$c=0;
foreach $l1 (@arr1){
      chomp($l1);
      @item1=split(/\t/,$l1);

      print OUT $item1[0]."\t".$item1[1];

      #RPKM = reads per kilobase per million
      #= [# of mapped reads]/([length of transcript]/1000)/([total reads]/10^6)
      $count_save="";
      for ($i=0; $i<$num_sample; $i++) {
              $k=1000000*$item1[2+$i]*1000/$total[$i]/$norLen;
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

      print OUT "\t$ratio\t$norLen\n";
        
}
close OUT;
