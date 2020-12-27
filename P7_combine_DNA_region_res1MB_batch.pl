$num = @ARGV;

if($num != 3)
{
	die "The number of parameter is not correct!\n";
}


$control_treat_list = $ARGV[0]; #/storage/htc/birchlerlab/DNAseq_SOL33/DNAseq_SOL33_control_treatment.txt
$map_dir = $ARGV[1]; #/storage/htc/birchlerlab/DNAseq_SOL33/results/P3_map_genome_bowtie2
$outputfolder = $ARGV[2]; #/storage/htc/birchlerlab/DNAseq_SOL33/results/P4_combine_counts




open(IN,"$control_treat_list") || die "Failed to open file $control_treat_list\n";


###### read control treat file
%control_list = ();
%treatment_list= ();
while(<IN>) #Treatment       1S9D    1S9D_S2_R1_001_trim_fastqc
{
  $line=$_;
  chomp $line;
  @tmp = split(/\t/,$line);
  $type = $tmp[0];
  $code = $tmp[1];
  
  if($type eq 'Control')
  {
    $control_list{$code}=1;
    
  }elsif($type eq 'Treatment')
  {
    $treatment_list{$code}=1;
  }else{
    die "Only Control and Treatment is allowed!\n";
  }
  
}
close IN;


####### get folder for each code


opendir(DIR,$map_dir) || die "Failed to open dir $map_dir\n";

@subdirs = readdir(DIR);

%code2folder = ();
closedir(DIR);

foreach $folder (@subdirs)
{
  chomp $folder; #9L9D_S8_R1_001_trim_fastqc
  if($folder eq '.' or $folder eq '..') # this is important
  {
    next;
  }
  @tmp2 = split(/\_/,$folder);
  $folder_code = $tmp2[0];
  
  if(exists($control_list{$folder_code}) or exists($treatment_list{$folder_code}))
  {
    
  }else{
    die "Doesn't find correct code $folder_code for folder $folder\n";
  }
  
  
  if(!exists($code2folder{$folder_code})) 
  {
    $code2folder{$folder_code} = $folder;
  }else{
    die "Duplicate code $folder_code\n";
  }
}


foreach $ctrl (sort keys %control_list)
{
  if(!exists($code2folder{$ctrl}))
  {
    print "Control code $ctrl not exists in folder $map_dir \n";
    next;
  }
  foreach $trt (sort keys %treatment_list)
  {
      
      if(!exists($code2folder{$trt}))
      {
        print "Treatment code $trt not exists in folder $map_dir \n";
        next;
      }
      
      $ctrl_mapfile = $map_dir.'/'.$code2folder{$ctrl}.'/'.$code2folder{$ctrl}.'_bowtie2_k10_mismatch_2_unique_bowtie_position_map_reso100_convertTo1MB.txt';
      $trt_mapfile = $map_dir.'/'.$code2folder{$trt}.'/'.$code2folder{$trt}.'_bowtie2_k10_mismatch_2_unique_bowtie_position_map_reso100_convertTo1MB.txt';
      
      if(!(-e $ctrl_mapfile ) or !(-e $trt_mapfile ) )
      {
        die "Couldn't find $ctrl_mapfile or $trt_mapfile\n";
      }
      
      $ctrlname = $code2folder{$ctrl};
      $trtname = $code2folder{$trt};
      if(index($ctrlname,'_trim_fastqc')>0)
      {
        $ctrlname = substr($ctrlname,0,index($ctrlname,'_trim_fastqc'));
      }
      
      if(index($trtname,'_trim_fastqc')>0)
      {
        $trtname = substr($trtname,0,index($trtname,'_trim_fastqc'));
      }
      
      $outfile = "$outputfolder/${ctrlname}_${trtname}_combine_raw_res1MB.txt";
      $outfile_RPKM = "$outputfolder/${ctrlname}_${trtname}_combine_raw_res1MB_RPKM.txt";
      print "Generating $outfile\n";
      
      ### combine file
      $status = system("perl script_folder/P7_combine_DNA_region.pl $ctrl_mapfile $trt_mapfile $ctrlname  $trtname $outfile");
      if($status)
      {
        die "Failed to run <perl script_folder/P7_combine_DNA_region.pl $ctrl_mapfile $trt_mapfile $ctrlname  $trtname $outfile>\n";
      }
      
      
      ### visualzie DNA
      $outfile_image =  "$outputfolder/${ctrlname}_${trtname}_combine_raw_res1MB.jpeg";
      $status = system("Rscript script_folder/P8_visualize_DNA.R  $outfile $outfile_image");
      if($status)
      {
        die "Failed to run <Rscript script_folder/P8_visualize_DNA.R  $outfile $outfile_image>\n";
      }
      
      
      
      ### normalize by RPKM
      $status = system("perl script_folder/P7_normalize_RPKM.pl $outfile  $outfile_RPKM 1000000  2");
      if($status)
      {
        die "Failed to run <perl script_folder/P7_normalize_RPKM.pl $outfile  $outfile_RPKM 1000000  2>\n";
      }

      ### visualzie DNA RPKM
      $outfile_image_RPKM =  "$outputfolder/${ctrlname}_${trtname}_combine_raw_res1MB_RPKM.jpeg";
      $status = system("Rscript script_folder/P8_visualize_DNA.R  $outfile_RPKM $outfile_image_RPKM");
      if($status)
      {
        die "Failed to run <Rscript script_folder/P8_visualize_DNA.R  $outfile_RPKM $outfile_image_RPKM>\n";
      }


  
  }
}
