options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)
print(args)
print(length(args))
if(length(args) != 2)
{
  stop("The number of parameter is not correct!\n")
}

inputfile = args[1]
outputfile = args[2]

library(ggplot2)

##### Fixed_Resolution1KB_multicom
raw_count=read.table(inputfile,head=F,sep="\t")


raw_count = raw_count[raw_count$V1 !='ChrMt',]
raw_count = raw_count[raw_count$V1 !='ChrPt',]
raw_count$V1=factor(raw_count$V1,levels = c("Chr1","Chr2","Chr3","Chr4","Chr5","Chr6","Chr7","Chr8","Chr9","Chr10","ChrMt","ChrPt"))
raw_count$V5[raw_count$V5==0]=1
raw_count$V5=log2(raw_count$V5)

jpeg(outputfile, width = 12, height = 4, units = 'in', res = 300)
ggplot(raw_count, aes(x=V2, y=V5,color=V1)) +
  geom_point(size = 0.8)+ theme_bw()+ facet_grid(~V1,scales="free_x")+ylim(c(-4,4))+
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  labs(x="", y="Ratio (log2)", title="") +  theme(legend.position="none") +
  theme(axis.line = element_line(colour = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank())
dev.off()


