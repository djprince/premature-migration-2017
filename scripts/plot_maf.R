.libPaths("/home/djprince/programs/R/x86_64-pc-linux-gnu-library/3.0/")
library(ggplot2)
args <- commandArgs()
input <- args[8]

input.file <- paste("RAD_maf/",input, sep = "")

af.in = read.table(input.file, sep=" ", header=F)

order = c("Eel_M", "Tri_M", "Sal_M", "Rog_M", "Sou_M", "Sil_M", "Puy_M", "Noo_M", "Tri_P", "Sal_P", "Rog_P", "Nor_P", "Sil_P", "Puy_P", "Noo_P")
n1 = length(order)
key = data.frame( V1 = c(1:15), V2 = rep("6", times = 15), V3 = c(1-round(seq(from = 0, to = 1, by = (1/(n1-1))), 2)))

af = rbind(af.in,key)
pdf(file = "plots/maf_plot.pdf", height = 6.5, width = 6.5)
ggplot(af, aes(x=af$V2, y=af$V1)) + 
  geom_tile(aes(fill = af$V3)) + theme_bw(base_size = 6) + theme_bw(base_size=6) +
  theme(axis.line=element_blank(),axis.ticks=element_blank(),
          axis.title.x=element_blank(),axis.title.y=element_blank(),
          legend.position="none", panel.background=element_blank(),
          panel.border=element_blank(),panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(),plot.background=element_blank()) +
  scale_fill_gradient( low="white", high="black") +  
  scale_y_discrete(breaks=c(1:15), labels = order) +
  scale_x_discrete(breaks=c(1:6), labels=c("537741", "569200", "569271", "592438", "595121", "key")) 
dev.off()
