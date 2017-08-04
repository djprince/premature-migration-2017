.libPaths("/home/djprince/programs/R/x86_64-pc-linux-gnu-library/3.0/")
library(optparse)
library(ggplot2)

option_list <- list(make_option(c('-i','--in_file'), action='store', type='character', default=NULL, help='Input file (lrt0 output from -doAsso 1)'),
                    make_option(c('-s','--spp'), action='store', type='character', default=NULL, help='Species (either St or Ch)'),
                    make_option(c('-o','--out_file'), action='store', type='character', default=NULL, help='Output file')
)
opt <- parse_args(OptionParser(option_list = option_list))

lrt0 = read.delim(opt$in_file)
spp = opt$spp
outfile = opt$out_file


lrt0$pval = pchisq(lrt0$LRT,1,lower.tail=F) 
lrt0$val = -log(lrt0$pval, 10)

inside.all = subset(lrt0, lrt0$Chromosome == "scaffold79929e")
inside = data.frame(
pos = inside.all$Position,
val = inside.all$val
)
outside.all = subset(lrt0, lrt0$Chromosome != "scaffold79929e")
outside = data.frame(
val = outside.all$val
)
trunc = trunc((length(outside$val)/1000), 0)

if (spp == "Ch"){
  flag1 = subset(inside, inside$pos == "540141")
  flag2 = subset(inside, inside$pos == "571600")
  flag3 = subset(inside, inside$pos == "571671")
  flag4 = subset(inside, inside$pos == "594838")
  flag5 = subset(inside, inside$pos == "597521")
  
  ggplot() + theme_bw(base_size = 6) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
    geom_point(data= inside, aes(x=inside$pos, y=inside$val), size = 1) + 
    scale_x_continuous(breaks=c(0,100000, 200000, 400000, 600000, 800000, 1000000, 1200000, 1400000, 1600000, 1800000, 2200000),labels=c("", "0.1", "0.2", "0.4", "0.6","0.8", "1.0", "1.2", "1.4", "1.6", "1.8", paste("Other SNPs \n(n>", trunc, "K)", sep =""))) +
    scale_y_continuous(breaks=c(0,5,10,15,20), labels=c("0","5","10","15","20")) +
    coord_cartesian(ylim = c(-0.25,17), xlim=c(0,2400000)) + 
    geom_text(data=flag1, aes_string(x=flag1$pos, y=flag1$val, label="1", vjust = -1), size = 2, color = 'red')+
    geom_text(data=flag2, aes_string(x=flag2$pos, y=flag2$val, label="2", vjust = -1), size = 2, color = 'red')+
    geom_text(data=flag3, aes_string(x=flag3$pos, y=flag3$val, label="3", vjust = -1), size = 2, color = 'red')+
    geom_text(data=flag4, aes_string(x=flag4$pos, y=flag4$val, label="4", vjust = -1), size = 2, color = 'red')+
    geom_text(data=flag5, aes_string(x=flag5$pos, y=flag5$val, label="5", vjust = -1), size = 2, color = 'red')+
    xlab(label = "Scaffold_79929e Position (Mb)") + 
    ylab(label = expression('-log'[10]*'(p-value)')) + theme(axis.title.y=element_text(), axis.title.x=element_text(angle=0, vjust=-.5, hjust=0.5)) +
    geom_boxplot(data = outside, outlier.size = 1, aes(x = c(seq(2080000,(length(outside$val)-1+2080000))), y= outside$val), color="black") +
    geom_vline(xintercept=2000000, aes(color='black'))
} else if (spp == "St"){
  flag1 = 652305
  flag2 = 597653
  
  ggplot() + theme_bw(base_size = 6) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
    geom_point(data= inside, aes(x=inside$pos, y=inside$val), size = 1) + 
    scale_x_continuous(breaks=c(0,100000, 200000, 400000, 600000, 800000, 1000000, 1200000, 1400000, 1600000, 1800000, 2200000),labels=c("", "0.1", "0.2", "0.4", "0.6","0.8", "1.0", "1.2", "1.4", "1.6", "1.8", paste("Other SNPs \n(n>", trunc, "K)", sep =""))) +
    scale_y_continuous(breaks=c(0,5,10,15,20), labels=c("0","5","10","15","20")) +
    coord_cartesian(ylim = c(-0.25,24), xlim=c(0,2400000)) +    
    geom_text(aes_string(x=flag1, y=23, label="1", vjust = -1), size = 2, color = 'red')+
    geom_text(aes_string(x=flag2, y=23, label="2", vjust = -1), size = 2, color = 'red')+
    xlab(label = "Scaffold_79929e Position (Mb)") + 
    ylab(label = expression('-log'[10]*'(p-value)')) + theme(axis.title.y=element_text(), axis.title.x=element_text(angle=0, vjust=-.5, hjust=0.5)) +
    geom_boxplot(data = outside, outlier.size = 1, aes(x = c(seq(2020000,(length(outside$val)-1+2020000))), y= outside$val), color="black") +
    geom_vline(xintercept=2000000, aes(color='black'))
}

ggsave(opt$out_file)
unlink("Rplots.pdf", force=TRUE)
