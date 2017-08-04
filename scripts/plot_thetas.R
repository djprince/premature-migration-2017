.libPaths("/home/djprince/programs/R/x86_64-pc-linux-gnu-library/3.0/")
library(ggplot2)
args <- commandArgs()
input <- args[8]

input.file <- paste("RAD_thetas/",input, sep = "")

dat <- read.table(input.file, sep="\t", header=T);
dat <- cbind(dat, num= c(4,5,11,12,1,2,8,9))

pdf("plots/Ump_thetas.pdf", height = 6.5, width = 6.5)
ggplot() + theme_bw(base_size = 8) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  geom_point(data=dat, aes(x = dat$num, y = dat$emp), size = 3, shape = "-") +
  geom_errorbar(aes(x=dat$num,ymin=dat$lo, ymax=dat$hi), width = 0, size = 0.2)  +
  scale_x_continuous(breaks=c(1,1.5,2,3,4,4.5,5,8,8.5,9,10,11,11.5,12), labels=c(expression(theta[{pi}]),"Mature",expression(theta[{s}]),"Genome-wide",expression(theta[{pi}]),"Premature",expression(theta[{s}]),expression(theta[{pi}]),"Mature",expression(theta[{s}]),"Greb1-L region",expression(theta[{pi}]),"Premature",expression(theta[{s}]))) +
  scale_y_continuous(trans = 'log2',breaks=c(0.00025, 0.0005, 0.001,0.002,0.004,0.008, 0.016), labels=c("0.00025", "0.0005","0.001","0.002","0.004","0.008", "0.016")) +
  coord_cartesian( ylim = c(0.000125, 0.012), xlim=c(0.25,12.75)) + 
  ylab(label = expression(paste(theta," per base"))) + xlab(label="")
dev.off()
