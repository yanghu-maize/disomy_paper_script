$num = @ARGV;

if($num != 3)
{
	die "The number of parameter is not correct!\n";
}


$control_treat_list = $ARGV[0]; #/storage/htc/birchlerlab/DNAseq_SOL37/DNAseq_SOL37_control_treatment.txt
$map_dir = $ARGV[1]; #/storage/htc/birchlerlab/DNAseq_SOL37/results/P3_map_genome_bowtie2
$outputfolder = $ARGV[2]; #/storage/htc/birchlerlab/DNAseq_SOL37/results/P4_combine_counts




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
      
      $ctrl_mapfile = $map_dir.'/'.$code2folder{$ctrl}.'/multicom-'.$code2folder{$ctrl}.'_newnew.txt';
      $trt_mapfile = $map_dir.'/'.$code2folder{$trt}.'/multicom-'.$code2folder{$trt}.'_newnew.txt';
      
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
      
      $outfile = "$outputfolder/${ctrlname}_${trtname}_combine_raw_genecount.txt";
      $outfile_RPKM = "$outputfolder/${ctrlname}_${trtname}_combine_raw_genecount_RPKM.txt";
      print "Generating $outfile\n";
      
      ### combine file
      $status = system("perl script_folder/P6_combine_two_gene_sample.pl $ctrl_mapfile $trt_mapfile $ctrlname  $trtname $outfile");
      if($status)
      {
        die "Failed to run <perl script_folder/P6_combine_two_gene_sample.pl $ctrl_mapfile $trt_mapfile $ctrlname  $trtname $outfile>\n";
      }
      
      
      ### visualzie DNA
      $outfile_image =  "$outputfolder/${ctrlname}_${trtname}_combine_raw_genecount.jpeg";
      $status = system("Rscript script_folder/P8_visualize_DNA_genecount_W22.R  $outfile $outfile_image");
      if($status)
      {
        die "Failed to run <Rscript script_folder/P8_visualize_DNA_genecount_W22.R  $outfile $outfile_image>\n";
      }
      
      
      ### visualize single chromosome 
      $chrid = substr($trtname,0,1);
      $chrid_check = substr($trtname,0,2); # in case of 10L
      if($chrid_check eq '10')
      {
        $chrid='10';
      }
      $chrid = 'chr'.$chrid;

      
      
      $outfile_image_chr = "$outputfolder/${ctrlname}_${trtname}_combine_raw_genecount_$chrid.jpeg";
      $status = system("Rscript script_folder/P8_visualize_DNA_genecount_single_chr_W22.R  $outfile $chrid $outfile_image_chr");
      if($status)
      {
        die "Failed to run <Rscript script_folder/P8_visualize_DNA_genecount_single_chr_W22.R  $outfile $chrid $outfile_image_chr>\n";
      }
      
      
      ### normalize by RPKM
      $status = system("perl script_folder/P6_normalize_two_gene_RPKM.pl $outfile  $outfile_RPKM");
      if($status)
      {
        die "Failed to run <perl script_folder/P6_normalize_two_gene_RPKM.pl $outfile  $outfile_RPKM >\n";
      }

      ### visualzie DNA RPKM
      $outfile_image_RPKM =  "$outputfolder/${ctrlname}_${trtname}_combine_raw_genecount_RPKM.jpeg";
      $status = system("Rscript script_folder/P8_visualize_DNA_genecount_W22.R  $outfile_RPKM $outfile_image_RPKM");
      if($status)
      {
        die "Failed to run <Rscript script_folder/P8_visualize_DNA_genecount_W22.R  $outfile_RPKM $outfile_image_RPKM>\n";
      }


      ### visualize single chromosome 
      $outfile_image_RPKM_chr = "$outputfolder/${ctrlname}_${trtname}_combine_raw_genecount_RPKM_$chrid.jpeg";
      $status = system("Rscript script_folder/P8_visualize_DNA_genecount_single_chr_W22.R  $outfile_RPKM $chrid $outfile_image_RPKM_chr");
      if($status)
      {
        die "Failed to run <Rscript script_folder/P8_visualize_DNA_genecount_single_chr_W22.R  $outfile_RPKM $chrid $outfile_image_RPKM_chr>\n";
      }
  
  }
}
