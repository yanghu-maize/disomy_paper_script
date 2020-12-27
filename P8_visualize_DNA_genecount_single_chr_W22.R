options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)
print(args)
print(length(args))
if(length(args) != 3)
{
  stop("The number of parameter is not correct!\n")
}

inputfile = args[1]
chromosome = args[2]
outputfile = args[3]

library(ggplot2)

##### Fixed_Resolution1KB_multicom
raw_count=read.table(inputfile,head=T,sep="\t")

#"Chromosome\tStart\tEnd\tGeneId\tIndex\t$ctrlname\t$trtname\tRatio\n";
raw_count = raw_count[raw_count$Chromosome == chromosome,]
#raw_count$Chromosome=factor(raw_count$Chromosome,levels = c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10"))
raw_count$Chromosome=factor(raw_count$Chromosome,levels = c(chromosome))
raw_count$Ratio[raw_count$Ratio==0]=1
raw_count$Ratio=log2(raw_count$Ratio)

jpeg(outputfile, width = 12, height = 4, units = 'in', res = 300)
ggplot(raw_count, aes(x=Index, y=Ratio,color=Chromosome)) +
  geom_point(size = 0.8)+ theme_bw()+ylim(c(-4,4))+
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  labs(x="", y="Ratio (log2)", title="") +  theme(legend.position="none") +
  theme(axis.line = element_line(colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())
dev.off()


